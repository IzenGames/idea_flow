import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idea_flow/App/Pages/Widgets/draggable_base_widget.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class BoardItem {
  BoardItem({
    required this.id,
    required Offset pos,
    this.size = const Size(160, 100),
    this.text = 'Note',
    required this.iseditingText,
  }) : position = pos.obs;

  final String id;
  final Rx<Offset> position; // world coords
  final Size size;
  String text;
  bool iseditingText;
}

class BoardController extends GetxController {
  final items = <String, BoardItem>{}.obs;
  final transform = TransformationController();

  double get scale => transform.value.getMaxScaleOnAxis();

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

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BoardController());
    final draggableC = Get.put(DraggableController());

    return Scaffold(
      body: Listener(
        // Optional: wheel-zoom around mouse cursor with Ctrl (desktop feel)
        onPointerSignal: (signal) {
          // Keep default InteractiveViewer controls first; add custom later if needed
        },
        child: InteractiveViewer(
          transformationController: c.transform,
          minScale: 0.25,
          maxScale: 4,
          boundaryMargin: const EdgeInsets.all(100000), // generous pan area
          constrained: false, // allow unbounded child
          child: SizedBox(
            width: 200000,
            height: 200000,
            child: Obx(() {
              return Stack(
                clipBehavior: Clip.none,
                children: c.items.values.map((item) {
                  return Obx(() {
                    final pos = item.position.value;
                    return Positioned(
                      left: pos.dx,
                      top: pos.dy,
                      child: _DraggableNote(item: item, board: c),
                    );
                  });
                }).toList(),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a note at the current viewport center
          final size = MediaQuery.of(context).size;
          c.addItem(c.screenToWorld(Offset(size.width / 2, size.height / 2)));
        },
        child: const Icon(Icons.post_add),
      ),
    );
  }
}

class _DraggableNote extends StatefulWidget {
  const _DraggableNote({required this.item, required this.board});

  final BoardItem item;
  final BoardController board;

  @override
  State<_DraggableNote> createState() => _DraggableNoteState();
}

class _DraggableNoteState extends State<_DraggableNote> {
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
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue[200],
            child: SizedBox(
              width: item.size.width,
              height: item.size.height,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onDoubleTap: () {
                    setState(() {
                      item.iseditingText = true;
                    });
                  },
                  child: item.iseditingText
                      ? TextField(
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          // add decoration to make it clear it's editable
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          autofocus: true,
                          controller: TextEditingController(text: item.text),
                          onSubmitted: (val) {
                            setState(() {
                              item.text = val;
                              item.iseditingText = false;
                            });
                          },
                        )
                      : Text(
                          item.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
