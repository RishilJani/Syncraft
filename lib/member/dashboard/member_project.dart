class MemberProject {
  final int id;
  final String name;
  final String description;
  final DateTime? dueDate; // Optional due date
  final int totalTasks;
  final int completedTasks;

  MemberProject({
    required this.id,
    required this.name,
    required this.description,
    this.dueDate,
    required this.totalTasks,
    required this.completedTasks,
  });
}