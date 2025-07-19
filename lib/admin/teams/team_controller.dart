import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TeamController extends GetxController {
  final String baseUrl = 'https://67c846b00acf98d07085c742.mockapi.io/teams'; // Replace this
  RxList<dynamic> teams = [].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("🔥 API Response: $data"); // <== add this
        teams.value = data;
      } else {
        print("❌ Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      isLoading(false);
    }
  }



  Future<bool> addTeam(Map<String, dynamic> teamData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(teamData),
      );

      if (response.statusCode == 201) {
        fetchTeams();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }
}
