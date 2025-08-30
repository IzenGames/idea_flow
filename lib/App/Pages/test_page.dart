import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idea_flow/App/Pages/Elements/image_element.dart';
import 'package:idea_flow/App/Pages/Elements/text_element.dart';
import 'package:idea_flow/App/Pages/Widgets/draggable_base_widget.dart';
import 'package:idea_flow/App/Pages/Widgets/sidebar.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class BoardItem {
  BoardItem({
    required this.id,
    required Offset pos,
    this.size = const Size(160, 100),
    this.text = 'Note',
    required this.iseditingText,
    bool pan = false,
  }) : position = pos.obs,
       canPan = pan.obs;

  final String id;
  final Rx<Offset> position; // world coords
  final Size size;
  String text;
  bool iseditingText;
  final RxBool canPan;
}

class BoardController extends GetxController {
  final items = <String, BoardItem>{}.obs;
  final transform = TransformationController();

  double get scale => transform.value.getMaxScaleOnAxis();
  RxBool caPan = RxBool(false);
  void addItem(Offset worldPos) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    items[id] = BoardItem(id: id, pos: worldPos, iseditingText: false);
  }

  // Optional: convert a screen point to world coordinates
  Offset screenToWorld(Offset screenPoint) {
    final inv = v.Matrix4.inverted(transform.value);
    final p = v.Vector3(screenPoint.dx, screenPoint.dy, 0);
    final r = inv.transform3(p);
    return Offset(r.x, r.y);
  }
}

class BoardView extends StatelessWidget {
  const BoardView({super.key});

  void onAddElement(
    BuildContext context,
    DraggableController draggableC,
    ElementType type,
  ) {
    _addElement(context, draggableC, type);
  }

  @override
  Widget build(BuildContext context) {
    final draggableC = Get.put(DraggableController());
    final boardC = Get.put(BoardController());
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            onAddPressed: () =>
                onAddElement(context, draggableC, ElementType.text),
            onImagePressed: () =>
                onAddElement(context, draggableC, ElementType.image),
          ),
          Expanded(
            child: Listener(
              onPointerSignal: (signal) {
                // Handle wheel zoom if needed
              },
              onPointerDown: (signal) {
                // Handle wheel zoom if needed
                print(signal.buttons);
                if (signal.buttons == kMiddleMouseButton) {
                  print("can pan");
                  boardC.caPan.value = true;
                } else {
                  print("no");
                  boardC.caPan.value = false;
                }
              },
              child: Obx(() {
                return InteractiveViewer(
                  transformationController: draggableC.transform,
                  minScale: 0.25,
                  maxScale: 4,
                  boundaryMargin: const EdgeInsets.all(100000),
                  constrained: false,
                  panEnabled: boardC.caPan.value,
                  child: SizedBox(
                    width: 200000,
                    height: 200000,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: draggableC.items.values.map((item) {
                        return Obx(() {
                          final pos = item.position.value;
                          return Positioned(
                            left: pos.dx,
                            top: pos.dy,
                            child: _buildElementByType(item, draggableC),
                          );
                        });
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addElement(context, draggableC, ElementType.text),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Element factory method
Widget _buildElementByType(DraggableItem item, DraggableController controller) {
  switch (item.type) {
    case ElementType.text:
      return TextElement(item: item, board: controller);
    case ElementType.image:
      // Return your ImageElement when you create it
      return ImageElement(item: item, board: controller);
    case ElementType.note:
      // Return your NoteElement when you create it
      return DraggableBaseWidget(
        item: item,
        board: controller,
        child: const Icon(Icons.note, size: 40),
      );
  }
}

void _addElement(
  BuildContext context,
  DraggableController controller,
  ElementType type,
) {
  final size = MediaQuery.of(context).size;
  final worldPos = controller.screenToWorld(
    Offset(size.width / 2, size.height / 2),
  );

  String? content;
  switch (type) {
    case ElementType.text:
      content = 'Double tap to edit';
      break;
    case ElementType.image:
      content = 'https://via.placeholder.com/160x100';
      break;
    case ElementType.note:
      content = 'New note';
      break;
  }

  controller.addItem(worldPos, type: type, content: content);
}
