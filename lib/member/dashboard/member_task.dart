class MemberTask {
  final int id;
  final String title;
  final String status; // e.g., "To Do", "In Progress", "Completed"
  final String? priority; // e.g., "High", "Medium", "Low"
  final DateTime? due_date;

  MemberTask({
    required this.id,
    required this.title,
    required this.status,
    this.priority,
    this.due_date,
  });

  factory MemberTask.fromMap(Map<String, dynamic> map) {
    return MemberTask(
      id: map['id'] as int,
      title: map['title'] as String,
      status: map['status'] as String,
      priority: map['priority'] as String?,
      // Handle DateTime parsing carefully, assuming it's stored as an ISO 8601 string or timestamp
      due_date: map['due_date'] == null
          ? null
          : (map['due_date'] is String
          ? DateTime.tryParse(map['due_date'] as String)
          : (map['due_date'] is int // Assuming timestamp in milliseconds
          ? DateTime.fromMillisecondsSinceEpoch(map['due_date'] as int)
          : null)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'priority': priority,
      // Store DateTime as ISO 8601 string
      'due_date': due_date?.toIso8601String(),
    };
  }

}