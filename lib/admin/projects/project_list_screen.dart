import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncraft/project_progress/project_progress_screen.dart';
import 'package:syncraft/utils/import_export.dart';
import 'project_controller.dart';
import 'project_model.dart';

class ProjectListScreen extends StatelessWidget {
  final ProjectController controller = Get.find<ProjectController>();

  // Theme Colors
  static const Color deepTeal = Color(0xFF015054);
  static const Color yellowishWhite = Color(0xFFEBF1CF);

   ProjectListScreen({super.key}){
     print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowishWhite,
      appBar: AppBar(
        title: const Text('All Projects'),
        backgroundColor: deepTeal,
        actions: [
          IconButton( onPressed: () => Get.toNamed('/add-project'),  icon: const Icon(Icons.add, color: yellowishWhite), ),
          IconButton( onPressed: () => showLogoutDialog(context), icon: const Icon(Icons.logout, color: yellowishWhite),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.projects.isEmpty) {
          return const Center(
            child: Text(
              'No projects found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.projects.length,
          itemBuilder: (context, index) {
            final Project project = controller.projects[index];

            return Card(
              color: Colors.white,
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: deepTeal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "Created: ${project.createdOn.split('T')[0]}",
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => ProjectProgressScreen(), arguments: {
                              'project': project,
                            });
                          },
                          icon: const Icon(Icons.bar_chart, size: 18),
                          label: const Text('Progress'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: deepTeal,
                            foregroundColor: yellowishWhite,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}