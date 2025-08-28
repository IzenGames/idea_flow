import 'package:get/get.dart';

class ProjectDetails {
  final RxString dateCreated;
  RxString lastModified;
  RxString name;
  RxString description;
  RxString color;
  final RxString thumbnail;

  ProjectDetails({
    required String dateCreated,
    required String lastModified,
    required String name,
    required String description,
    required String color,
    required String thumbnail,
  }) : dateCreated = dateCreated.obs,
       lastModified = lastModified.obs,
       name = name.obs,
       description = description.obs,
       color = color.obs,
       thumbnail = thumbnail.obs;

  factory ProjectDetails.fromJson(Map<String, dynamic> json) => ProjectDetails(
    dateCreated: json["dateCreated"],
    lastModified: json["lastModified"],
    name: json["name"],
    description: json["description"],
    color: json["color"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "dateCreated": dateCreated.value,
    "lastModified": lastModified.value,
    "name": name.value,
    "description": description.value,
    "color": color.value,
    "thumbnail": thumbnail.value,
  };

  void updateFromJson(Map<String, dynamic> json) {
    dateCreated.value = json["dateCreated"];
    lastModified.value = json["lastModified"];
    name.value = json["name"];
    description.value = json["description"];
    color.value = json["color"];
    thumbnail.value = json["thumbnail"];
  }
}

class ProjectSettings {
  final RxString canvasBackground;
  final RxInt gridSize;
  final RxBool snapToGrid;

  ProjectSettings({
    required String canvasBackground,
    required int gridSize,
    required bool snapToGrid,
  }) : canvasBackground = canvasBackground.obs,
       gridSize = gridSize.obs,
       snapToGrid = snapToGrid.obs;

  factory ProjectSettings.fromJson(Map<String, dynamic> json) =>
      ProjectSettings(
        canvasBackground: json["canvasBackground"],
        gridSize: json["gridSize"],
        snapToGrid: json["snapToGrid"],
      );

  Map<String, dynamic> toJson() => {
    "canvasBackground": canvasBackground.value,
    "gridSize": gridSize.value,
    "snapToGrid": snapToGrid.value,
  };

  void updateFromJson(Map<String, dynamic> json) {
    canvasBackground.value = json["canvasBackground"];
    gridSize.value = json["gridSize"];
    snapToGrid.value = json["snapToGrid"];
  }
}

class ProjectModel {
  final String id;
  final ProjectDetails details;
  final ProjectSettings settings;
  final RxList<String> boards;

  ProjectModel({
    required this.id,
    required this.details,
    required this.settings,
    required List<String> boards,
  }) : boards = boards.obs;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json["id"],
    details: ProjectDetails.fromJson(json["details"]),
    settings: ProjectSettings.fromJson(json["settings"]),
    boards: List<String>.from(json["boards"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "details": details.toJson(),
    "settings": settings.toJson(),
    "boards": List<dynamic>.from(boards.map((x) => x)),
  };

  void updateFromJson(Map<String, dynamic> json) {
    if (json["details"] != null) {
      details.updateFromJson(json["details"]);
    }
    if (json["settings"] != null) {
      settings.updateFromJson(json["settings"]);
    }
    if (json["boards"] != null) {
      boards.value = List<String>.from(json["boards"]);
    }
  }
}
