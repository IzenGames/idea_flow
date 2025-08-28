import 'package:get/get.dart';
import 'package:idea_flow/App/Models/project_model.dart';
import 'package:idea_flow/App/controllers/projects_controller.dart';

class ProjectController extends GetxController {
  final ProjectsController projectsController = Get.find<ProjectsController>();
  final RxMap<String, ProjectModel> projects = <String, ProjectModel>{}.obs;
  final RxString selectedProjectId = ''.obs;

  // Get a project by ID
  ProjectModel? getProjectByID(String id) => projects[id];

  // Get all project IDs
  List<String> get projectIds => projects.keys.toList();

  // Get selected project
  ProjectModel? get selectedProject => projects[selectedProjectId.value];

  // Load projects (simulated)
  void loadProjects() {
    // Simulate loading from storage/API
    final sampleProjects = [
      ProjectModel.fromJson({
        "id": "1",
        "details": {
          "dateCreated": "2025-08-27T21:08:33.712333",
          "lastModified": "2025-08-27T21:08:33.712333",
          "name": "Game Design Document",
          "description": "Main project for our RPG game development",
          "color": "#FF5733",
          "thumbnail": "assets/thumbnails/project1.png",
        },
        "settings": {
          "canvasBackground": "#FFFFFF",
          "gridSize": 20,
          "snapToGrid": true,
        },
        "boards": ["board_1", "board_2", "board_3"],
      }),
      ProjectModel.fromJson({
        "id": "2",
        "details": {
          "dateCreated": "2025-08-28T10:15:22.123456",
          "lastModified": "2025-08-28T10:15:22.123456",
          "name": "Marketing Website",
          "description": "Company marketing website redesign",
          "color": "#3498DB",
          "thumbnail": "assets/thumbnails/project2.png",
        },
        "settings": {
          "canvasBackground": "#F8F9FA",
          "gridSize": 15,
          "snapToGrid": false,
        },
        "boards": ["board_4", "board_5"],
      }),
    ];

    projects.clear();
    for (var project in sampleProjects) {
      projects[project.id] = project;
    }

    // Select first project by default
    if (projects.isNotEmpty && selectedProjectId.isEmpty) {
      selectedProjectId.value = projects.keys.first;
    }
  }

  // Create a new project
  String createProject({
    required String newId,
    required String name,
    String description = '',
  }) {
    final now = DateTime.now().toIso8601String();

    final newProject = ProjectModel(
      id: newId,
      details: ProjectDetails(
        dateCreated: now,
        lastModified: now,
        name: name,
        description: description,
        color:
            "#${((1 << 24) * 0.5 + (1 << 24) * 0.5 * 0.5).toInt().toRadixString(16).padLeft(6, '0')}",
        thumbnail: "assets/thumbnails/default.png",
      ),
      settings: ProjectSettings(
        canvasBackground: "#FFFFFF",
        gridSize: 20,
        snapToGrid: true,
      ),
      boards: [],
    );

    projects[newId] = newProject;
    selectedProjectId.value = newId;

    return newId;
  }

  // Update project details
  void updateProjectDetails(String id, Map<String, dynamic> details) {
    final project = projects[id];
    if (project != null) {
      project.details.updateFromJson({
        ...details,
        "lastModified": DateTime.now().toIso8601String(),
      });
      projects.refresh();
    }
  }

  // Update project settings
  void updateProjectSettings(String id, Map<String, dynamic> settings) {
    final project = projects[id];
    if (project != null) {
      project.settings.updateFromJson(settings);
      projects.refresh();
    }
  }

  // Add board to project
  void addBoard(String id, String boardId) {
    final project = projects[id];
    if (project != null) {
      project.boards.add(boardId);
      project.details.lastModified.value = DateTime.now().toIso8601String();
      projects.refresh();
    }
  }

  // Remove board from project
  void removeBoard(String id, String boardId) {
    final project = projects[id];
    if (project != null) {
      project.boards.remove(boardId);
      project.details.lastModified.value = DateTime.now().toIso8601String();
      projects.refresh();
    }
  }

  // Delete project
  void deleteProject(String id) {
    projects.remove(id);
    if (selectedProjectId.value == id) {
      selectedProjectId.value = projects.isNotEmpty ? projects.keys.first : '';
    }
  }

  // Select a project
  void selectProject(String id) {
    if (projects.containsKey(id)) {
      selectedProjectId.value = id;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }
}
