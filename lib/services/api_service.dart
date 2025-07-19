import 'dart:convert';
import 'package:http/http.dart' as http;
import '../admin/projects/project_model.dart';
import '../admin/teams/team_model.dart';

class ApiService {
  static const baseUrl = 'https://64be8f02bcaba46138cde9fd.mockapi.io/api/v1';

  // Projects
  static Future<List<Project>> fetchProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/projects'));
    return (jsonDecode(response.body) as List)
        .map((data) => Project.fromJson(data))
        .toList();
  }

  static Future<void> addProject(Project project) async {
    await http.post(
      Uri.parse('$baseUrl/projects'),
      body: jsonEncode(project.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Teams
  static Future<List<Team>> fetchTeams() async {
    final response = await http.get(Uri.parse('$baseUrl/teams'));
    return (jsonDecode(response.body) as List)
        .map((data) => Team.fromJson(data))
        .toList();
  }
}
