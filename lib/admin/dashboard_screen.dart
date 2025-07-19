import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Weekly Progress Chart
  Widget _buildWeeklyProgress() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final heights = [0.6, 0.9, 0.75, 0.5, 0.8, 0.4, 0.3]; // 0.0 - 1.0

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Task Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: heights[index] * 120,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(days[index]),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  // Reusable Project Card
  Widget _buildCard({
    required String title,
    required String subtitle,
    required String route,
    required Color color,
    required double progress,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text("${(progress * 100).toInt()}% Completed",
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Drawer
  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 32, backgroundColor: Colors.purple),
                SizedBox(height: 12),
                Text("Admin",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("admin@example.com",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.purple),
            title: const Text("Dashboard"),
            onTap: () => Get.toNamed('/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Colors.purple),
            title: const Text("Projects"),
            onTap: () => Get.toNamed('/projects'),
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.purple),
            title: const Text("Teams"),
            onTap: () => Get.toNamed('/teams'),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.purple),
            title: const Text("Profile"),
            onTap: () => Get.toNamed('/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () => Get.offAllNamed('/login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      backgroundColor: const Color(0xFFF8F6FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Quick Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            isMobile
                ? Column(
              children: [
                _buildCard(
                    title: "Projects",
                    subtitle: "All project tasks and progress",
                    route: '/projects',
                    color: Colors.purple,
                    progress: 0.7),
                _buildCard(
                    title: "Teams",
                    subtitle: "Your team assignments",
                    route: '/teams',
                    color: Colors.orange,
                    progress: 0.6),
              ],
            )
                : Row(
              children: [
                Expanded(
                  child: _buildCard(
                      title: "Projects",
                      subtitle: "All project tasks and progress",
                      route: '/projects',
                      color: Colors.purple,
                      progress: 0.7),
                ),
                Expanded(
                  child: _buildCard(
                      title: "Teams",
                      subtitle: "Your team assignments",
                      route: '/teams',
                      color: Colors.orange,
                      progress: 0.6),
                ),
              ],
            ),
            _buildWeeklyProgress(),
          ],
        ),
      ),
    );
  }
}
