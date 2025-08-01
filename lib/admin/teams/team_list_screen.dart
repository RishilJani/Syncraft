import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'team_controller.dart';

class TeamListScreen extends StatelessWidget {
  final TeamController controller = Get.find<TeamController>();
  final RxInt expandedIndex = (-1).obs;

  static const Color deepTeal = Color(0xFF015054);
  static const Color yellowishWhite = Color(0xFFEBF1CF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowishWhite,
      appBar: AppBar(
        title: const Text('Teams'),
        backgroundColor: deepTeal,
        foregroundColor: yellowishWhite,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add Team",
            onPressed: () async {
              final result = await Get.toNamed('/add-team');
              if (result == true) {
                controller.fetchTeams();
              }
            },
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: deepTeal));
        }

        if (controller.teams.isEmpty) {
          return const Center(
            child: Text(
              "No teams available",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.teams.length,
          itemBuilder: (context, index) {
            final team = controller.teams[index];
            final members = team['team_member_id'] ?? [];
            final isAssigned = team['assigned'] == true;

            return Obx(() {
              final isExpanded = expandedIndex.value == index;

              return Card(
                color: yellowishWhite,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      tileColor: deepTeal.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        team['name']?.toString() ??
                            team['team_name']?.toString() ??
                            'Unnamed Team',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: deepTeal,
                        ),
                      ),
                      subtitle: Text(
                        isAssigned ? '✅ Assigned' : '❌ Not Assigned',
                        style: TextStyle(
                          color: isAssigned ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: deepTeal,
                      ),
                      onTap: () {
                        expandedIndex.value = isExpanded ? -1 : index;
                      },
                    ),

                    // MEMBER LIST
                    if (isExpanded && members is List && members.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(thickness: 1.2),
                            ...members.map((member) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person, color: deepTeal),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        member.toString(),
                                        style: const TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.info_outline, color: Colors.grey),
                                      tooltip: 'View Profile',
                                      onPressed: () {
                                        Get.toNamed('/member-profile', arguments: member);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList()
                          ],
                        ),
                      ),

                    // No Members
                    if (isExpanded && (members == null || members.isEmpty))
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text("No members", style: TextStyle(color: Colors.grey)),
                      ),
                  ],
                ),
              );
            });
          },
        );
      }),
    );
  }
}
