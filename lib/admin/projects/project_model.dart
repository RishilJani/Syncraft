class Project {
  final String id;
  final String title;
  final String description;
  final double progress;
  final String teamId;

  Project({required this.id, required this.title, required this.description, required this.progress, required this.teamId});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      progress: double.tryParse(json['progress'].toString()) ?? 0.0,
      teamId: json['teamId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "progress": progress,
    "teamId": teamId,
  };
}
