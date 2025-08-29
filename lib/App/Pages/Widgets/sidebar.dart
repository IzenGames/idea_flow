import 'package:flutter/material.dart';
import 'package:idea_flow/App/Pages/Widgets/Components/sidebar_button.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key, required this.onAddPressed}) : super(key: key);
  final void Function() onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SidebarButton(icon: Icons.add, onPressed: onAddPressed),

        // Add more sidebar buttons or widgets here
      ],
    );
  }
}
