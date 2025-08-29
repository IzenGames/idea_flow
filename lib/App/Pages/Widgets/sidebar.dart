import 'package:flutter/material.dart';
import 'package:idea_flow/App/Pages/Widgets/Components/sidebar_button.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key? key,
    required this.onAddPressed,
    required this.onImagePressed,
  }) : super(key: key);
  final void Function() onAddPressed;
  final void Function() onImagePressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SidebarButton(icon: Icons.add, onPressed: onAddPressed),
        SidebarButton(icon: Icons.image, onPressed: onImagePressed),
        // Add more sidebar buttons or widgets here
      ],
    );
  }
}
