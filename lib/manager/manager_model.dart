class ManagerTask {
  final String id;
  String title;
  String description;
  String status; // 'pending', 'in progress', 'in review', 'completed'
  String assignedTo;
  List<Map<String, String>> comments; // Each map: {'text': '...', 'time': '...'}

  ManagerTask({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'pending',
    this.assignedTo = '',
    List<Map<String, String>>? comments,
  }) : comments = comments ?? [];

  ManagerTask copyWith({
    String? id,
    String? title,
    String? description,
    String? assignedTo,
    String? status,
    List<Map<String, String>>? comments,
  }) {
    return ManagerTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      comments: comments ?? this.comments,
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