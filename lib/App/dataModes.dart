// Project model
class IdeaFlowProject {
  final String id;
  final ProjectDetails details;
  final ProjectSettings settings;
  final List<String> boards;

  IdeaFlowProject({
    required this.id,
    required this.details,
    required this.settings,
    required this.boards,
  });

  factory IdeaFlowProject.fromJson(Map<String, dynamic> json) {
    return IdeaFlowProject(
      id: json['id'],
      details: ProjectDetails.fromJson(json['details']),
      settings: ProjectSettings.fromJson(json['settings']),
      boards: List<String>.from(json['boards']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'details': details.toJson(),
      'settings': settings.toJson(),
      'boards': boards,
    };
  }
}

class ProjectDetails {
  final DateTime dateCreated;
  final DateTime lastModified;
  final String name;
  final String description;
  final String color;
  final String? thumbnail;

  ProjectDetails({
    required this.dateCreated,
    required this.lastModified,
    required this.name,
    required this.description,
    required this.color,
    this.thumbnail,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return ProjectDetails(
      dateCreated: DateTime.parse(json['dateCreated']),
      lastModified: DateTime.parse(json['lastModified']),
      name: json['name'],
      description: json['description'],
      color: json['color'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateCreated': dateCreated.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'name': name,
      'description': description,
      'color': color,
      'thumbnail': thumbnail,
    };
  }
}

class ProjectSettings {
  final String canvasBackground;
  final int gridSize;
  final bool snapToGrid;

  ProjectSettings({
    required this.canvasBackground,
    required this.gridSize,
    required this.snapToGrid,
  });

  factory ProjectSettings.fromJson(Map<String, dynamic> json) {
    return ProjectSettings(
      canvasBackground: json['canvasBackground'],
      gridSize: json['gridSize'],
      snapToGrid: json['snapToGrid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canvasBackground': canvasBackground,
      'gridSize': gridSize,
      'snapToGrid': snapToGrid,
    };
  }
}

// Board model
class IdeaFlowBoard {
  final String id;
  final BoardDetails details;
  final List<Note> notes;
  final List<BoardColumn> columns;
  final List<BoardImage> images;

  IdeaFlowBoard({
    required this.id,
    required this.details,
    required this.notes,
    required this.columns,
    required this.images,
  });

  factory IdeaFlowBoard.fromJson(Map<String, dynamic> json) {
    return IdeaFlowBoard(
      id: json['id'],
      details: BoardDetails.fromJson(json['details']),
      notes: List<Note>.from(json['notes'].map((x) => Note.fromJson(x))),
      columns: List<BoardColumn>.from(json['columns'].map((x) => BoardColumn.fromJson(x))),
      images: List<BoardImage>.from(json['images'].map((x) => BoardImage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'details': details.toJson(),
      'notes': List<dynamic>.from(notes.map((x) => x.toJson())),
      'columns': List<dynamic>.from(columns.map((x) => x.toJson())),
      'images': List<dynamic>.from(images.map((x) => x.toJson())),
    };
  }
}

class BoardDetails {
  final String name;
  final String description;
  final String icon;
  final String color;
  final String? parent;
  final List<String> children;

  BoardDetails({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.parent,
    required this.children,
  });

  factory BoardDetails.fromJson(Map<String, dynamic> json) {
    return BoardDetails(
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      parent: json['parent'],
      children: List<String>.from(json['children']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'parent': parent,
      'children': children,
    };
  }
}

class Note {
  final String id;
  final Position position;
  final Size size;
  final String content;
  final NoteStyle style;

  Note({
    required this.id,
    required this.position,
    required this.size,
    required this.content,
    required this.style,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      position: Position.fromJson(json['position']),
      size: Size.fromJson(json['size']),
      content: json['content'],
      style: NoteStyle.fromJson(json['style']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position.toJson(),
      'size': size.toJson(),
      'content': content,
      'style': style.toJson(),
    };
  }
}

class Position {
  final double x;
  final double y;

  Position({required this.x, required this.y});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}

class Size {
  final double width;
  final double height;

  Size({required this.width, required this.height});

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
    };
  }
}

class NoteStyle {
  final String backgroundColor;
  final String borderColor;
  final int borderWidth;
  final int borderRadius;

  NoteStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  factory NoteStyle.fromJson(Map<String, dynamic> json) {
    return NoteStyle(
      backgroundColor: json['backgroundColor'],
      borderColor: json['borderColor'],
      borderWidth: json['borderWidth'],
      borderRadius: json['borderRadius'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'borderColor': borderColor,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,
    };
  }
}

class BoardColumn {
  final String id;
  final String name;
  final Position position;
  final Size size;
  final ColumnStyle style;
  final List<String> noteIds;

  BoardColumn({
    required this.id,
    required this.name,
    required this.position,
    required this.size,
    required this.style,
    required this.noteIds,
  });

  factory BoardColumn.fromJson(Map<String, dynamic> json) {
    return BoardColumn(
      id: json['id'],
      name: json['name'],
      position: Position.fromJson(json['position']),
      size: Size.fromJson(json['size']),
      style: ColumnStyle.fromJson(json['style']),
      noteIds: List<String>.from(json['noteIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position.toJson(),
      'size': size.toJson(),
      'style': style.toJson(),
      'noteIds': noteIds,
    };
  }
}

class ColumnStyle {
  final String backgroundColor;
  final String borderColor;
  final int borderWidth;
  final int borderRadius;

  ColumnStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  factory ColumnStyle.fromJson(Map<String, dynamic> json) {
    return ColumnStyle(
      backgroundColor: json['backgroundColor'],
      borderColor: json['borderColor'],
      borderWidth: json['borderWidth'],
      borderRadius: json['borderRadius'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'borderColor': borderColor,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,
    };
  }
}

class BoardImage {
  final String id;
  final String path;
  final Position position;
  final Size size;

  BoardImage({
    required this.id,
    required this.path,
    required this.position,
    required this.size,
  });

  factory BoardImage.fromJson(Map<String, dynamic> json) {
    return BoardImage(
      id: json['id'],
      path: json['path'],
      position: Position.fromJson(json['position']),
      size: Size.fromJson(json['size']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'position': position.toJson(),
      'size': size.toJson(),
    };
  }
}