import 'package:flutter/material.dart';
import 'package:idea_flow/App/Pages/Widgets/draggable_base_widget.dart';

class ImageElement extends StatelessWidget {
  const ImageElement({required this.item, required this.board});
  final DraggableItem item;
  final DraggableController board;

  @override
  void initState() {
    item.size = Size(600, 300);
  }

  @override
  Widget build(BuildContext context) {
    item.size = Size(500, 300);

    return DraggableBaseWidget(
      item: item,
      board: board,
      child: const Icon(Icons.image, size: 100),
    );
  }
}
