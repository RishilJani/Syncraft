import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProjectProgressController extends GetxController {
  var isLoading = true.obs;
  var hasFetched = false.obs;
  var tasks = <Map<String, dynamic>>[].obs;

  Future<void> fetchTasksForProject(String projectId) async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          'https://syncraft-api-server.onrender.com/tasks/project/$projectId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        tasks.value = List<Map<String, dynamic>>.from(data);
        hasFetched.value = true;
      } else {
        print('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      isLoading(false);
    }
  }
}
