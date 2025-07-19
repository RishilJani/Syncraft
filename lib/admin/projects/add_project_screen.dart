import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'project_controller.dart';

class AddProjectScreen extends StatelessWidget {
  final ProjectController controller = Get.find<ProjectController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9F7FF),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  "Project Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Project Title',
                    hintText: 'Enter project title',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter project description',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dateTimeController,
                  decoration: InputDecoration(
                    labelText: 'Date & Time',
                    hintText: 'e.g., 2025-07-20 15:00',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        dateTimeController.text.isEmpty) {
                      Get.snackbar("Error", "Please fill all fields");
                      return;
                    }

                    final success = await controller.addProject({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'datetime': dateTimeController.text,
                    });

                    if (success) {
                      Get.snackbar("Success", "Project created successfully");
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop(); // fallback
                      });
                    }

                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create Project"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
