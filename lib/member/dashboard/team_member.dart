class TeamMember {
  final int id;
  final String name;
  final String role;

  TeamMember({required this.id, required this.name, required this.role});

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null || map['name'] == null || map['role'] == null) {
      throw FormatException(
          "Missing required fields (id, name, role) in TeamMember map: $map");
    }

    return TeamMember(
      id: map['id'] as int,
      name: map['name'] as String,
      role: map['role'] as String,
    );
  }
}