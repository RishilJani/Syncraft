import 'package:syncraft/utils/import_export.dart';

class ManagerController extends ChangeNotifier {
  List<ManagerModel> projects = [];
  final RxList<ManagerTask> tasks = <ManagerTask>[].obs;
  final uuid = Uuid();
  bool isLoading = false;

  // Add new task to project (now supports attachments)
  void addTask(
      ManagerModel project,
      String title,
      String description,
      String assignedTo, {
        required String priority,
        required DateTime deadline,
        List<String> attachments = const [],
      }) {
    final newTask = ManagerTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      assignedTo: assignedTo,
      status: 'pending',
      priority: priority,
      deadline: deadline,
      comments: [],
      attachments: attachments,
    );

    project.tasks.add(newTask);
    notifyListeners();
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

  void addAttachmentToTask(ManagerModel project, String taskId, String attachmentUrl) {
    final task = project.tasks.firstWhere((t) => t.id == taskId, orElse: () => throw Exception("Task not found"));
    task.attachments = [...task.attachments, attachmentUrl];
    notifyListeners();
  }

  // Task summary functions
  int getTotalTasks(ManagerModel project) => project.tasks.length;
  int getCompletedTasks(ManagerModel project) => project.tasks.where((t) => t.status == 'completed').length;
  int getToDoTasks(ManagerModel project) => project.tasks.where((t) => t.status == 'in progress').length;
  int getInReviewTasks(ManagerModel project) => project.tasks.where((t) => t.status == 'in review').length;
  int getPendingTasks(ManagerModel project) => project.tasks.where((t) => t.status == 'pending').length;
}