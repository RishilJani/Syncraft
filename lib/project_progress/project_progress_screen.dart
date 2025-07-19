// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:syncraft/admin/projects/project_controller.dart';
//
// class ProjectProgressScreen extends StatelessWidget {
//   ProjectProgressScreen({super.key});
//
//   final ProjectController controller = Get.find<ProjectController>();
//
//   final taskLabels = ['Completed', 'Pending', 'In Progress', 'Reviewing'];
//   final taskColors = [Colors.green, Colors.red, Colors.orange, Colors.blueAccent];
//
//   final RxBool isLoading = true.obs;
//   final RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;
//
//   Future<void> fetchTasks() async {
//     await Future.delayed(const Duration(seconds: 1));
//     tasks.value = [
//       {'title': 'UI Design', 'status': 'completed'},
//       {'title': 'API Setup', 'status': 'pending'},
//       {'title': 'Login Integration', 'status': 'in_progress'},
//       {'title': 'Dashboard UI', 'status': 'in_progress'},
//       {'title': 'Database Config', 'status': 'completed'},
//       {'title': 'Bug Fixing', 'status': 'pending'},
//       {'title': 'Testing & QA', 'status': 'completed'},
//       {'title': 'Code Review', 'status': 'reviewing'},
//       {'title': 'Security Audit', 'status': 'reviewing'},
//     ];
//     isLoading.value = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     fetchTasks(); // call once on build
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Project Progress'),
//         backgroundColor: Colors.purple,
//         elevation: 0,
//
//       ),
//       body: Obx(() {
//         if (isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final project = controller.selectedProject;
//         final title = project['title'] ?? 'No Title';
//         final description = project['description'] ?? 'No Description';
//         final deadline = project['datetime'] ?? 'No Deadline';
//
//         final completed = tasks.where((t) => t['status'] == 'completed').toList();
//         final pending = tasks.where((t) => t['status'] == 'pending').toList();
//         final inProgress = tasks.where((t) => t['status'] == 'in_progress').toList();
//         final reviewing = tasks.where((t) => t['status'] == 'reviewing').toList();
//
//         final taskData = [
//           completed.length.toDouble(),
//           pending.length.toDouble(),
//           inProgress.length.toDouble(),
//           reviewing.length.toDouble(),
//         ];
//         final taskLists = [completed, pending, inProgress, reviewing];
//         final total = tasks.length.toDouble();
//
//         return LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 🟪 Project Info
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.purple.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.purple.shade100),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple)),
//                         const SizedBox(height: 10),
//                         Text(description, style: const TextStyle(fontSize: 16)),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                             const SizedBox(width: 6),
//                             Text("Deadline: $deadline", style: const TextStyle(fontSize: 14, color: Colors.grey)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//
//                   // 📊 Pie Chart
//                   const Text(
//                     'Task Status Overview',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 20),
//                   AspectRatio(
//                     aspectRatio: constraints.maxWidth < 600 ? 1.2 : 2.2,
//                     child: PieChart(
//                       PieChartData(
//                         sectionsSpace: 6,
//                         centerSpaceRadius: 40,
//                         pieTouchData: PieTouchData(enabled: false),
//                         sections: List.generate(taskData.length, (index) {
//                           final value = taskData[index];
//                           if (value == 0) return null;
//                           final percent = ((value / total) * 100).toStringAsFixed(1);
//                           return PieChartSectionData(
//                             color: taskColors[index],
//                             value: value,
//                             title: '$percent%',
//                             radius: 80,
//                             titleStyle: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           );
//                         }).whereType<PieChartSectionData>().toList(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // 🏷️ Legends
//                   Wrap(
//                     spacing: 16,
//                     runSpacing: 12,
//                     children: List.generate(taskLabels.length, (index) {
//                       return IntrinsicWidth(
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 14,
//                               height: 14,
//                               decoration: BoxDecoration(
//                                 color: taskColors[index],
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             Flexible(
//                               child: Text(
//                                 taskLabels[index],
//                                 style: const TextStyle(fontSize: 14),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 30),
//
//                   // ⬇️ Task Lists
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: taskLists.length,
//                     itemBuilder: (context, index) {
//                       final label = taskLabels[index];
//                       final taskGroup = taskLists[index];
//
//                       return ExpansionTile(
//                         title: Text(
//                           '$label Tasks',
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         children: taskGroup.map((task) {
//                           return ListTile(
//                             leading: const Icon(Icons.task_alt, color: Colors.purple),
//                             title: Text(task['title']),
//                           );
//                         }).toList(),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:syncraft/admin/projects/project_controller.dart';
//
// class ProjectProgressScreen extends StatelessWidget {
//   ProjectProgressScreen({super.key});
//
//   final ProjectController controller = Get.find<ProjectController>();
//
//   final taskLabels = ['Completed', 'Pending', 'In Progress', 'Reviewing'];
//   final taskColors = [Colors.green, Colors.red, Colors.orange, Colors.blueAccent];
//
//   final RxBool isLoading = true.obs;
//   final RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;
//
//   Future<void> fetchTasks() async {
//     await Future.delayed(const Duration(seconds: 1));
//     tasks.value = [
//       {'title': 'UI Design', 'status': 'completed'},
//       {'title': 'API Setup', 'status': 'pending'},
//       {'title': 'Login Integration', 'status': 'in_progress'},
//       {'title': 'Dashboard UI', 'status': 'in_progress'},
//       {'title': 'Database Config', 'status': 'completed'},
//       {'title': 'Bug Fixing', 'status': 'pending'},
//       {'title': 'Testing & QA', 'status': 'completed'},
//       {'title': 'Code Review', 'status': 'reviewing'},
//       {'title': 'Security Audit', 'status': 'reviewing'},
//     ];
//     isLoading.value = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     fetchTasks(); // call once on build
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Project Progress'),
//         backgroundColor: Colors.purple,
//         elevation: 0,
//
//       ),
//       body: Obx(() {
//         if (isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final project = controller.selectedProject;
//         final title = project['title'] ?? 'No Title';
//         final description = project['description'] ?? 'No Description';
//         final deadline = project['datetime'] ?? 'No Deadline';
//
//         final completed = tasks.where((t) => t['status'] == 'completed').toList();
//         final pending = tasks.where((t) => t['status'] == 'pending').toList();
//         final inProgress = tasks.where((t) => t['status'] == 'in_progress').toList();
//         final reviewing = tasks.where((t) => t['status'] == 'reviewing').toList();
//
//         final taskData = [
//           completed.length.toDouble(),
//           pending.length.toDouble(),
//           inProgress.length.toDouble(),
//           reviewing.length.toDouble(),
//         ];
//         final taskLists = [completed, pending, inProgress, reviewing];
//         final total = tasks.length.toDouble();
//
//         return LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 🟪 Project Info
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.purple.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.purple.shade100),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple)),
//                         const SizedBox(height: 10),
//                         Text(description, style: const TextStyle(fontSize: 16)),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                             const SizedBox(width: 6),
//                             Text("Deadline: $deadline", style: const TextStyle(fontSize: 14, color: Colors.grey)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//
//                   // 📊 Pie Chart
//                   const Text(
//                     'Task Status Overview',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 20),
//                   AspectRatio(
//                     aspectRatio: constraints.maxWidth < 600 ? 1.2 : 2.2,
//                     child: PieChart(
//                       PieChartData(
//                         sectionsSpace: 6,
//                         centerSpaceRadius: 40,
//                         pieTouchData: PieTouchData(enabled: false),
//                         sections: List.generate(taskData.length, (index) {
//                           final value = taskData[index];
//                           if (value == 0) return null;
//                           final percent = ((value / total) * 100).toStringAsFixed(1);
//                           return PieChartSectionData(
//                             color: taskColors[index],
//                             value: value,
//                             title: '$percent%',
//                             radius: 80,
//                             titleStyle: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           );
//                         }).whereType<PieChartSectionData>().toList(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // 🏷️ Legends
//                   Wrap(
//                     spacing: 16,
//                     runSpacing: 12,
//                     children: List.generate(taskLabels.length, (index) {
//                       return IntrinsicWidth(
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 14,
//                               height: 14,
//                               decoration: BoxDecoration(
//                                 color: taskColors[index],
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             Flexible(
//                               child: Text(
//                                 taskLabels[index],
//                                 style: const TextStyle(fontSize: 14),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 30),
//
//                   // ⬇️ Task Lists
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: taskLists.length,
//                     itemBuilder: (context, index) {
//                       final label = taskLabels[index];
//                       final taskGroup = taskLists[index];
//
//                       return ExpansionTile(
//                         title: Text(
//                           '$label Tasks',
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         children: taskGroup.map((task) {
//                           return ListTile(
//                             leading: const Icon(Icons.task_alt, color: Colors.purple),
//                             title: Text(task['title']),
//                           );
//                         }).toList(),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'project_progress_controller.dart';
import 'package:syncraft/admin/projects/project_model.dart';

class ProjectProgressScreen extends StatelessWidget {
  ProjectProgressScreen({super.key});

  final ProjectProgressController controller = Get.put(ProjectProgressController());

  final RxInt selectedIndex = (-1).obs;
  final taskLabels = ['Completed', 'Pending', 'In Progress', 'Reviewing'];
  final taskColors = [Colors.green, Colors.red, Colors.orange, Colors.blueAccent];

  @override
  Widget build(BuildContext context) {
    final Project? project = Get.arguments?['project'];
    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('❌ Project data not provided')),
      );
    }

    // Fetch tasks for given project ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasFetched.value) {
        controller.fetchTasksForProject(project.id.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Progress'),
        backgroundColor: Colors.purple,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = controller.tasks;
        print('tasks ===== $tasks');
        final completed = tasks.where((t) => t['status'] == 'completed').toList();
        final pending = tasks.where((t) => t['status'] == 'pending').toList();
        final inProgress = tasks.where((t) => t['status'] == 'in progress').toList();
        final reviewing = tasks.where((t) => t['status'] == 'reviewing').toList();

        final taskData = [
          completed.length.toDouble(),
          pending.length.toDouble(),
          inProgress.length.toDouble(),
          reviewing.length.toDouble(),
        ];

        final taskLists = [completed, pending, inProgress, reviewing];
        final total = tasks.length.toDouble();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟪 Project Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name ?? 'Unnamed Project',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        )),
                    const SizedBox(height: 10),
                    Text(project.description ?? 'No description provided.',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text("Deadline: ${project.dueDate ?? 'N/A'}",
                            style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 📊 Pie Chart
              const Text('Task Status Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.4,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 6,
                    centerSpaceRadius: 40,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        if (event is FlTapUpEvent &&
                            pieTouchResponse?.touchedSection != null) {
                          selectedIndex.value =
                              pieTouchResponse!.touchedSection!.touchedSectionIndex;
                        }
                      },
                    ),
                    sections: List.generate(taskData.length, (index) {
                      final value = taskData[index];
                      if (value == 0) return null;
                      final percent = ((value / total) * 100).toStringAsFixed(1);
                      return PieChartSectionData(
                        color: taskColors[index],
                        value: value,
                        title: '$percent%',
                        radius: selectedIndex.value == index ? 85 : 80,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).whereType<PieChartSectionData>().toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ⬇️ Task Expandable List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: taskLists.length,
                itemBuilder: (context, index) {
                  final label = taskLabels[index];
                  final taskGroup = taskLists[index];

                  return Obx(() => ExpansionTile(
                    key: ValueKey('$label-${taskGroup.length}'),
                    initiallyExpanded: selectedIndex.value == index,
                    title: Text('$label Tasks',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    children: taskGroup.map((task) {
                      return ListTile(
                        leading: const Icon(Icons.task_alt, color: Colors.purple),
                        title: Text(task['title'] ?? 'Untitled'),
                      );
                    }).toList(),
                  ));
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}




















