// To parse this JSON data, do
//
//     final projectsModel = projectsModelFromJson(jsonString);

import 'dart:convert';

List<String> projectsModelFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));

String projectsModelToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
