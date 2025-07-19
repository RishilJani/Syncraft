import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProjectController extends GetxController {
  var projects = [].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://67c846b00acf98d07085c742.mockapi.io/project';

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        projects.value = jsonDecode(response.body);
      } else {
        Get.snackbar("Error", "Failed to load projects");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }


  Future<bool> addProject(Map<String, dynamic> projectData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(projectData),
      );

      if (response.statusCode == 201) {
        fetchProjects(); // refresh list
        return true;
      } else {
        Get.snackbar("Error", "Failed to add project");
        return false;
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
      return false;
    }
  }

}