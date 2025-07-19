class ManagerTask {
  final String id;
  String title;
  String description;
  String status; // 'pending', 'completed_but_pending_review', 'completed'
  String assignedTo;
  List<String> comments;

  ManagerTask({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'pending',
    this.assignedTo = '',
    this.comments = const [],
  });
}

class ManagerModel {
  final String id;
  String name;
  List<ManagerTask> tasks;
  List<String> teamMembers;

  ManagerModel({
    required this.id,
    required this.name,
    this.tasks = const [],
    this.teamMembers = const [],
  });
}