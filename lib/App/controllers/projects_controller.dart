import 'package:get/get.dart';
import 'package:idea_flow/App/Models/projects_model.dart';

class ProjectsController extends GetxController {
  final Rx<ProjectsModel> projectsModel = ProjectsModel(
    projects: RxList<String>(),
  ).obs;

  @override
  void onInit() {
    loadProjects();
    super.onInit();
  }

  void loadProjects() async {
    // Replace with your actual data loading logic
    projectsModel.update((model) {
      model?.projects.value = ["1", "2"];
    });

    final projects = projectsModel.value.projects;
  }

  Future<bool> addProject(String newId) async {
    try {
      projectsModel.update((model) {
        model?.projects.add(newId);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Helper method to access projects list easily
  RxList<String> get projects => projectsModel.value.projects;
}
