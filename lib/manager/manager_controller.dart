import 'package:syncraft/utils/import_export.dart';

class ManagerController {
  List<ManagerModel> projects = [];
  final uuid = Uuid();

  // Add new task to project
  void addTask(ManagerModel project, String title, String description, String assignedTo) {
    final task = ManagerTask(
      id: uuid.v4(),
      title: title,
      description: description,
      assignedTo: assignedTo,
    );
    project.tasks.add(task);
  }

  // Update status of a task
  void updateTaskStatus(ManagerModel project, String taskId, String newStatus) {
    final task = project.tasks.firstWhere((t) => t.id == taskId, orElse: () => throw Exception('Task not found'));
    task.status = newStatus;
  }

  // Project progress based on completed tasks
  double getProgress(ManagerModel project) {
    int completed = project.tasks.where((t) => t.status == 'completed').length;
    return project.tasks.isEmpty ? 0 : completed / project.tasks.length;
  }

  // Task progress for progress indicator
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

  // Update task details
  void updateTaskDetails(ManagerModel project, String taskId, String title, String desc, String assignedTo) {
    final index = project.tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      project.tasks[index] = project.tasks[index].copyWith(
        title: title,
        description: desc,
        assignedTo: assignedTo,
      );
    }
  }

  // Add comment with timestamp to a task
  void addCommentToTask(ManagerModel project, String taskId, Map<String, String> comment) {
    final task = project.tasks.firstWhere((t) => t.id == taskId, orElse: () => throw Exception("Task not found"));
    task.comments = [...task.comments, comment];
  }

  // Task summary functions
  int getTotalTasks(ManagerModel project) => project.tasks.length;
  int getCompletedTasks(ManagerModel project) => project.tasks.where((t) => t.status == 'completed').length;
  int getToDoTasks(ManagerModel project) => project.tasks.where((t) => t.status == 'in progress').length;
  int getInReviewTasks(ManagerModel project) => project.tasks.where((t) => t.status == 'in review').length;
  int getPendingTasks(ManagerModel project) => project.tasks.where((t) => t.status == 'pending').length;
}