import 'package:flutter/material.dart';
import 'package:idea_flow/App/Models/project_model.dart';
import 'package:idea_flow/App/controllers/project_controller.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key, required this.projectId}) : super(key: key);

  final String projectId;
  @override
  Widget build(BuildContext context) {
    final ProjectController projectController = ProjectController();
    final ProjectModel project;

    return Scaffold(
      appBar: AppBar(title: Text("fds")),
      body: Center(child: Text('Project details for $projectId')),
    );
  }
}
