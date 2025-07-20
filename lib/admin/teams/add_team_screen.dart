import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncraft/admin/teams/team_controller.dart';

class AddTeamScreen extends StatefulWidget {
  const AddTeamScreen({super.key});

  @override
  State<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
  final TeamController controller = Get.find();

  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController memberIdController = TextEditingController();
  final RxList<String> memberIds = <String>[].obs;

  static const Color deepTeal = Color(0xFF015054);
  static const Color yellowishWhite = Color(0xFFEBF1CF);

  @override
  void dispose() {
    teamNameController.dispose();
    memberIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowishWhite,
      appBar: AppBar(
        title: const Text("Add Team"),
        backgroundColor: deepTeal,
        foregroundColor: yellowishWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: teamNameController,
              decoration: InputDecoration(
                labelText: 'Team Name',
                hintText: 'Enter team name',
                labelStyle: const TextStyle(color: deepTeal),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: deepTeal),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.group, color: deepTeal),
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Team Members:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: deepTeal),
                ),
                ...memberIds.map((id) => ListTile(
                  title: Text(id),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => memberIds.remove(id),
                  ),
                )),
              ],
            )),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: memberIdController,
                    decoration: InputDecoration(
                      labelText: 'Member ID',
                      hintText: 'Enter member ID',
                      labelStyle: const TextStyle(color: deepTeal),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: deepTeal),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person_add, color: deepTeal),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (memberIdController.text.isNotEmpty) {
                      memberIds.add(memberIdController.text.trim());
                      memberIdController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepTeal,
                    foregroundColor: yellowishWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (teamNameController.text.isEmpty || memberIds.isEmpty) {
                  Get.snackbar("Error", "Please fill all fields");
                  return;
                }

                final success = await controller.addTeam({
                  'team_name': teamNameController.text.trim(),
                  'team_member_id': memberIds,
                });

                if (success) {
                  Get.back();
                  Get.snackbar("Success", "Team created successfully");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: deepTeal,
                foregroundColor: yellowishWhite,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Create Team"),
            ),
          ],
        ),
      ),
    );
  }
}
