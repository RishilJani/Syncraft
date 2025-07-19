class Team {
  final String id;
  final String name;
  final String adminId;
  final bool assigned;
  final List<String> members; // Still keep it for future use if needed

  Team({
    required this.id,
    required this.name,
    required this.adminId,
    required this.assigned,
    this.members = const [],
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unnamed Team',
      adminId: json['admin_id'].toString(),
      assigned: json['assigned'] ?? false,
      members: List<String>.from(json['members'] ?? []), // Optional
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "admin_id": adminId,
    "assigned": assigned,
    "members": members,
  };
}
