import 'package:flutter/material.dart';
import 'package:idea_flow/App/Pages/Widgets/draggable_base_widget.dart';

class TextElement extends StatefulWidget {
  const TextElement({required this.item, required this.board});
  final DraggableItem item;
  final DraggableController board;

  @override
  State<TextElement> createState() => _TextElementState();
}

class _TextElementState extends State<TextElement> {
  final TextEditingController _textController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.item.content ?? 'Double tap to edit';

    widget.item.size = Size(300, 50);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: () {
        // TODO : Create drop box
      },
      onDoubleTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: DraggableBaseWidget(
        item: widget.item,
        board: widget.board,
        child: _isEditing
            ? Column(
                children: [
                  TextField(
                    controller: _textController,
                    autofocus: true,

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _isEditing = false;
                        // Update item content if needed
                        _textController.text = value;
                      });
                    },
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _textController.text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
