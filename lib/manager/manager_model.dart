class ManagerTask {
  String id;
  String title;
  String description;
  String assignedTo;
  String status;
  String priority;
  DateTime deadline;
  List<Map<String, String>> comments;
  List<String> attachments;

  ManagerTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.status,
    required this.priority,
    required this.deadline,
    required this.comments,
    this.attachments = const [],
  });

  ManagerTask copyWith({
    String? id,
    String? title,
    String? description,
    String? assignedTo,
    String? status,
    String? priority,
    DateTime? deadline,
    List<Map<String, String>>? comments,
    List<String>? attachments,
  }) {
    return ManagerTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
    );
  }
}

class ManagerModel {
  final String id;
  String managerName;
  String projectName;
  List<ManagerTask> tasks;
  List<String> teamMembers;

  ManagerModel({
    required this.id,
    required this.managerName,
    required this.projectName,
    this.tasks = const [],
    this.teamMembers = const [],
  });

  // Task count getters
  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((t) => t.status == 'completed').length;
  int get inProgressTasks => tasks.where((t) => t.status == 'in progress').length;
  int get inReviewTasks => tasks.where((t) => t.status == 'in review').length;
  int get toDoTasks => tasks.where((t) => t.status == 'pending').length;
}