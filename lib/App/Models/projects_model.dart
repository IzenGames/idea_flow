// To parse this JSON data, do
//
//     final projectsModel = projectsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

ProjectsModel projectsModelFromJson(String str) =>
    ProjectsModel.fromJson(json.decode(str));

String projectsModelToJson(ProjectsModel data) => json.encode(data.toJson());

class ProjectsModel {
  final RxList<String> projects;

  ProjectsModel({required this.projects});

  factory ProjectsModel.fromJson(Map<String, dynamic> json) => ProjectsModel(
    projects: RxList<String>.from(json["projects"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "projects": List<dynamic>.from(projects.map((x) => x)),
  };
}
