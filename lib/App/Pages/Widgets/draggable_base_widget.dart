import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class DraggableBaseWidget extends StatefulWidget {
  const DraggableBaseWidget({
    required this.item,
    required this.board,
    required this.child,
  });

  final DraggableItem item;
  final DraggableController board;
  final Widget child;

  @override
  State<DraggableBaseWidget> createState() => _DraggableBaseWidgetState();
}

class _DraggableBaseWidgetState extends State<DraggableBaseWidget> {
  late Offset startPos;
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final c = widget.board;

    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.move,
        child: GestureDetector(
          onPanStart: (details) {
            startPos = item.position.value;
          },
          onPanUpdate: (details) {
            // Convert screen delta to world delta by dividing by zoom
            final worldDelta = details.delta / c.scale;
            item.position.value = item.position.value + worldDelta;
          },
          // onPanEnd: () {
          //   // TODO: persist new position (e.g., repository.save)
          // },
          child: Stack(
            alignment: AlignmentGeometry.bottomRight,
            children: [
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue[200],
                child: Obx(() {
                  return SizedBox(
                    width: item.elementSize.value.width,
                    height: item.elementSize.value.height,
                    child: widget.child,
                  );
                }),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeftDownRight,
                child: GestureDetector(
                  onPanStart: (details) {
                    item.elementSize.value = Size(
                      item.elementSize.value.width + 50,
                      item.elementSize.value.height + 50,
                    );
                  },
                  child: Icon(Icons.line_style_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DraggableItem {
  DraggableItem({
    required this.id,
    required Offset pos,
    required Size size,
    this.type = ElementType.text, // Use ElementType enum
    this.content,
  }) : position = pos.obs,
       elementSize = size.obs;

  final String id;
  final Rx<Offset> position;
  // Size size;
  final Rx<Size> elementSize;
  final ElementType type; // Use ElementType enum
  final String? content;
}

class DraggableController extends GetxController {
  final items = <String, DraggableItem>{}.obs;
  final transform = TransformationController();

  double get scale => transform.value.getMaxScaleOnAxis();

  void addItem(
    Offset worldPos, {
    ElementType type = ElementType.text,
    String? content,
  }) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    items[id] = DraggableItem(
      id: id,
      pos: worldPos,
      size: Size(160, 100),
      type: type,
      content: content,
    );
  }

  Offset screenToWorld(Offset screenPoint) {
    final inv = v.Matrix4.inverted(transform.value);
    final p = v.Vector3(screenPoint.dx, screenPoint.dy, 0);
    final r = inv.transform3(p);
    return Offset(r.x, r.y);
  }
}

enum ElementType { text, image, note }
