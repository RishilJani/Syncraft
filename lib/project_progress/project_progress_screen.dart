import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'project_progress_controller.dart';
import 'package:syncraft/admin/projects/project_model.dart';

class ProjectProgressScreen extends StatelessWidget {
  ProjectProgressScreen({super.key});

  final ProjectProgressController controller = Get.put(ProjectProgressController());
  final RxInt selectedIndex = (-1).obs;

  // Theme Colors
  static const Color deepTeal = Color(0xFF015054);
  static const Color yellowishWhite = Color(0xFFEBF1CF);

  final taskLabels = ['Pending', 'In Progress', 'Reviewing', 'Completed'];
  final taskColors = [Colors.red, Colors.orange, Colors.blueAccent, Colors.green];

  @override
  Widget build(BuildContext context) {
    final Project? project = Get.arguments?['project'];
    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('❌ Project data not provided')),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasFetched.value) {
        controller.fetchTasksForProject(project.id.toString());
      }
    });

    return Scaffold(
      backgroundColor: yellowishWhite,
      appBar: AppBar(
        title: const Text('Project Progress'),
        backgroundColor: deepTeal,
        foregroundColor: yellowishWhite,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = controller.tasks;
        print(tasks);
        final pending = tasks.where((t) => t['status'] == 'to do').toList();
        final inProgress = tasks.where((t) => t['status'] == 'in progress').toList();
        final reviewing = tasks.where((t) => t['status'] == 'in review').toList();
        final completed = tasks.where((t) => t['status'] == 'completed').toList();

        final taskData = [
          pending.length.toDouble(),
          inProgress.length.toDouble(),
          reviewing.length.toDouble(),
          completed.length.toDouble(),
        ];

        final taskLists = [pending, inProgress, reviewing, completed];
        final total = tasks.length.toDouble();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟩 Project Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: deepTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: deepTeal.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name ?? 'Unnamed Project',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: deepTeal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      project.description ?? 'No description provided.',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "Deadline: ${project.dueDate ?? 'N/A'}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 📊 Pie Chart
              const Text(
                'Task Status Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: deepTeal,
                ),
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.4,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
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
                    title: Text(
                      '$label Tasks',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: deepTeal,
                      ),
                    ),
                    iconColor: deepTeal,
                    collapsedIconColor: deepTeal,
                    children: taskGroup.map((task) {
                      return ListTile(
                        leading: const Icon(Icons.task_alt, color: deepTeal),
                        title: Text(
                          task['title'] ?? 'Untitled',
                          style: const TextStyle(color: Colors.black87),
                        ),
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
