import 'package:flutter/material.dart';
import 'package:idea_flow/App/Models/project_model.dart';
import 'package:idea_flow/App/Pages/Widgets/sidebar.dart';
import 'package:idea_flow/App/Pages/test_page.dart';
import 'package:idea_flow/App/controllers/project_controller.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key, required this.projectId, required this.title})
    : super(key: key);

  final String projectId;
  final String title;
  @override
  Widget build(BuildContext context) {
    final ProjectController projectController = ProjectController();
    final ProjectModel project;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        child: Row(
          children: [
            // Sidebar(),
            Expanded(child: BoardView()),
          ],
        ),
      ),
    );
  }
}
