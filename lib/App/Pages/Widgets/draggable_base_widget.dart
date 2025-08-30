import 'dart:ui';

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
  late Size startSize;
  bool _isResizing = false;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final c = widget.board;

    return RepaintBoundary(
      child: Listener(
        onPointerDown: (details) {
          // Claim the pointer to prevent InteractiveViewer from handling it
          if (details.kind == PointerDeviceKind.mouse ||
              details.kind == PointerDeviceKind.stylus ||
              details.kind == PointerDeviceKind.invertedStylus ||
              details.kind == PointerDeviceKind.unknown) {
            // For mouse and stylus, we need to claim the pointer
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.move,
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _isDragging = true;
              });
              startPos = item.position.value;
            },
            onPanUpdate: (details) {
              if (_isResizing) return;

              // Convert screen delta to world delta by dividing by zoom
              final worldDelta = details.delta / c.scale;
              item.position.value = item.position.value + worldDelta;
            },
            onPanEnd: (details) {
              setState(() {
                _isDragging = false;
              });
            },
            onPanCancel: () {
              setState(() {
                _isDragging = false;
              });
            },
            child: Obx(() {
              return Container(
                width: item.elementSize.value.width,
                height: item.elementSize.value.height,
                child: Stack(
                  children: [
                    // Main content
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[200],
                      child: Container(
                        width: item.elementSize.value.width,
                        height: item.elementSize.value.height,
                        child: widget.child,
                      ),
                    ),

                    // Resize handle
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.resizeUpLeftDownRight,
                        child: GestureDetector(
                          onPanStart: (details) {
                            setState(() {
                              _isResizing = true;
                              _isDragging = false;
                              startSize = item.elementSize.value;
                              startPos = details.globalPosition;
                            });
                          },
                          onPanUpdate: (details) {
                            final delta =
                                (details.globalPosition - startPos) / c.scale;

                            // Convert to double explicitly
                            final newWidth = (startSize.width + delta.dx)
                                .clamp(50.0, 500.0)
                                .toDouble();
                            final newHeight = (startSize.height + delta.dy)
                                .clamp(50.0, 500.0)
                                .toDouble();

                            item.elementSize.value = Size(newWidth, newHeight);
                          },
                          onPanEnd: (details) {
                            setState(() {
                              _isResizing = false;
                            });
                          },
                          onPanCancel: () {
                            setState(() {
                              _isResizing = false;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,

                            child: Transform.flip(
                              flipY: true,
                              child: Icon(
                                Icons.open_in_full,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
    this.type = ElementType.text,
    this.content,
  }) : position = pos.obs,
       elementSize = size.obs;

  final String id;
  final Rx<Offset> position;
  final Rx<Size> elementSize;
  final ElementType type;
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
