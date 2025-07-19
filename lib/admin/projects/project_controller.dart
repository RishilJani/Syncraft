import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'project_model.dart';

class ProjectController extends GetxController {
  var projects = <Project>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://syncraft-api-server.onrender.com/projects';

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  /// ✅ Fetch all projects
  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        projects.value = data.map((item) => Project.fromJson(item)).toList();
      } else {
        Get.snackbar("Error", "Failed to load projects: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception while fetching projects: $e");
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Add new project
  Future<bool> addProject(Project project) async {
    try {
      final jsonData = project.toJson();
      print("📤 Sending: $jsonData");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );

      print("📥 Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchProjects(); // refresh after adding
        return true;
      } else {
        Get.snackbar("Error", "Failed to add project: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Error: $e");
      Get.snackbar("Exception", e.toString());
      return false;
    }
  }
}
