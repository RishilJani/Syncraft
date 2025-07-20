import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncraft/admin/projects/project_controller.dart';
import 'package:syncraft/admin/projects/project_model.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final ProjectController controller = Get.find<ProjectController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  static const Color deepTeal = Color(0xFF015054);
  static const Color yellowishWhite = Color(0xFFEBF1CF);

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project'),
        backgroundColor: deepTeal,
        elevation: 0,
        foregroundColor: yellowishWhite,
      ),
      backgroundColor: yellowishWhite,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
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
                    color: deepTeal,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Project Name',
                    hintText: 'Enter project name',
                    prefixIcon: const Icon(Icons.title, color: deepTeal),
                    labelStyle: const TextStyle(color: deepTeal),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: deepTeal),
                    ),
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
                    prefixIcon: const Icon(Icons.description, color: deepTeal),
                    labelStyle: const TextStyle(color: deepTeal),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: deepTeal),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: dateTimeController,
                  decoration: InputDecoration(
                    labelText: 'Due Date (optional)',
                    hintText: 'e.g., 2025-07-20',
                    prefixIcon: const Icon(Icons.calendar_today, color: deepTeal),
                    labelStyle: const TextStyle(color: deepTeal),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: deepTeal),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: () async {
                    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                      Get.snackbar("Error", "Please fill at least name and description");
                      return;
                    }

                    final project = Project(
                      id: '0',
                      name: nameController.text,
                      description: descriptionController.text,
                      adminId: 1,
                      dueDate: dateTimeController.text.isEmpty ? null : dateTimeController.text,
                      createdOn: DateTime.now().toIso8601String(),
                    );

                    final success = await controller.addProject(project);

                    if (success) {
                      Get.snackbar("Success", "Project created successfully");
                      await Future.delayed(const Duration(milliseconds: 300));
                      Get.back(); // Close screen
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create Project"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepTeal,
                    foregroundColor: yellowishWhite,
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
