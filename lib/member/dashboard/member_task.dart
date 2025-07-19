class MemberTask {
  final int id;
  final String title;
  final String status; // e.g., "To Do", "In Progress", "Completed"
  final String? priority; // e.g., "High", "Medium", "Low"
  final DateTime? taskDueDate;

  MemberTask({
    required this.id,
    required this.title,
    required this.status,
    this.priority,
    this.taskDueDate,
  });
}