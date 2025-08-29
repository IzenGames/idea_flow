import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class DraggableBaseWidget extends StatefulWidget {
  const DraggableBaseWidget({required this.item, required this.board});

  final DraggableItem item;
  final DraggableController board;

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
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue[200],
            child: SizedBox(width: item.size.width, height: item.size.height),
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
    this.size = const Size(160, 100),
  }) : position = pos.obs;

  final String id;
  final Rx<Offset> position;
  final Size size;
}

class DraggableController extends GetxController {
  final items = <String, DraggableItem>{}.obs;
  final transform = TransformationController();

  double get scale => transform.value.getMaxScaleOnAxis();

  void addItem(Offset worldPos) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    items[id] = DraggableItem(id: id, pos: worldPos);
  }

  Offset screenToWorld(Offset screenPoint) {
    final inv = v.Matrix4.inverted(transform.value);
    final p = v.Vector3(screenPoint.dx, screenPoint.dy, 0);
    final r = inv.transform3(p);
    return Offset(r.x, r.y);
  }
}
