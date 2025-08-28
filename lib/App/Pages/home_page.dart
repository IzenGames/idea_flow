import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idea_flow/App/Pages/project_page.dart';
import 'package:idea_flow/App/controllers/project_controller.dart';
import 'package:idea_flow/App/controllers/projects_controller.dart';
import 'package:idea_flow/App/helpers/h_app.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final projectsController = Get.put(ProjectsController());
  final projectController = Get.put(ProjectController());

  @override
  void initState() {
    super.initState();
    projectsController.loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Idea Flow'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            List<String> projects = projectsController.projects;
            if (projects.isEmpty) {
              print(projects);
              return const Text('No projects found.');
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final projectName =
                    projectController
                        .getProjectByID(projects[index])
                        ?.details
                        .name ??
                    'Unknown';
                return InkWell(
                  onTap: () {
                    openProjectPage(projects[index]);
                  },
                  child: Card(
                    color: Colors.grey[800],
                    child: Center(
                      child: Text(
                        projectName.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add popup to add new project
          showDialog(
            context: context,
            builder: (context) {
              String projectName = '';
              return AlertDialog(
                title: const Text('Add New Project'),
                content: TextField(
                  onChanged: (value) {
                    projectName = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter project name',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (projectName.isNotEmpty) {
                        final newId = HApp().createNewProjectID();
                        String newProjectId = projectController.createProject(
                          newId: newId,
                          name: projectName,
                        );
                        await projectsController.addProject(newId);
                        Navigator.of(context).pop();
                        openProjectPage(newProjectId);
                      }
                    },
                    child: const Text('Add'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  // open project page
  void openProjectPage(String projectId) {
    // Navigate to the project page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectPage(projectId: projectId),
      ),
    );
  }
}
