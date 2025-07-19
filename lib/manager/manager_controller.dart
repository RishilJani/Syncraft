import 'package:syncraft/utils/import_export.dart';

class ManagerController {
  List<ManagerModel> projects = [];
  final uuid = Uuid();

  void addTask(ManagerModel project, String title, String description, String assignedTo) {
    final task = ManagerTask(
      id: uuid.v4(),
      title: title,
      description: description,
      assignedTo: assignedTo,
    );
    project.tasks.add(task);
  }

  void updateTaskStatus(ManagerModel project, String taskId, String newStatus) {
    final task = project.tasks.firstWhere((t) => t.id == taskId, orElse: () => throw Exception('Task not found'));
    task.status = newStatus;
  }

  double getProgress(ManagerModel project) {
    int completed = project.tasks.where((t) => t.status == 'completed').length;
    return project.tasks.isEmpty ? 0 : completed / project.tasks.length;
  }

  double getTaskProgress(ManagerTask task) {
    switch (task.status) {
      case 'completed':
        return 1.0;
      case 'in review':
        return 0.8;
      case 'in progress':
        return 0.5;
      default:
        return 0.2;
    }
  }

}