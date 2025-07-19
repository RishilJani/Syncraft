class Project {
  final String? id;
  final String name;
  final String description;
  final int adminId;
  final String? dueDate;
  final String createdOn;

  Project({
    this.id,
    required this.name,
    required this.description,
    required this.adminId,
    this.dueDate,
    required this.createdOn,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      adminId: json['admin_id'] ?? 0,
      dueDate: json['due_date'],
      createdOn: json['created_on'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'description': description,
      'admin_id': adminId,
      'created_on': createdOn,
    };

    if (dueDate != null) {
      data['due_date'] = dueDate as Object;
    }

    return data;
  }
}
