import 'package:flutter/material.dart';

class SidebarButton extends StatelessWidget {
  const SidebarButton({required this.icon, required this.onPressed});
  final IconData icon;
  // onPressed action can be passed as a parameter if needed
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.all(16.0),
        ),
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}
