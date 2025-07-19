

import '../../utils/import_export.dart';

class AddTeamScreen extends StatelessWidget {
  final TeamController controller = Get.find();

  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController memberIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxList<String> memberIds = <String>[].obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Team"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: teamNameController,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Team Members:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...memberIds.map((id) => ListTile(
                  title: Text(id),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
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
                    decoration: const InputDecoration(
                      labelText: 'Member ID',
                      border: OutlineInputBorder(),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: const Text("Add",style: TextStyle(color: Colors.white),),
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
                backgroundColor: Colors.purple,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Create Team",style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
