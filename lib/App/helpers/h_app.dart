import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:idea_flow/App/Models/projects_model.dart';

class HApp {
  // Future<List<String>> loadStringArray() async {
  //   ProjectsModel projectsModel = ProjectsModel(
  //     projects: ["1", "2", "3", "4", "5"],
  //   );
  //   return projectsModel.projects;
  // }

  Future<bool> addProject(String projectName) async {
    return false;
  }

  String createNewProjectID() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    return newId;
  }
}
