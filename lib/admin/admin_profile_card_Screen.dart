import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminProfileCardScreen extends StatelessWidget {
  final Map<String, dynamic> adminData;

  const AdminProfileCardScreen({super.key, required this.adminData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF015054)),
      backgroundColor: const Color(0xFFEBF1CF), // Yellowish White
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/image2.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double cardWidth = constraints.maxWidth < 600
                    ? MediaQuery.of(context).size.width * 0.9
                    : 500;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: AdminProfileCard(
                      admin: adminData,
                      width: cardWidth,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminProfileCard extends StatelessWidget {
  final Map<String, dynamic> admin;
  final double width;

  const AdminProfileCard({super.key, required this.admin, required this.width});

  static const Color deepTeal = Color(0xFF015054);
  static const Color yellowishWhite = Color(0xFFEBF1CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: yellowishWhite,
        boxShadow: [const BoxShadow(blurRadius: 10, color: Colors.black26)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: deepTeal,
                ),
              ),
              const Positioned(
                bottom: -40,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/images/image1.png"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  admin['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: deepTeal,
                  ),
                ),
                Text(
                  "Admin ID: ${admin['admin_id']}",
                  style: TextStyle(color: deepTeal.withOpacity(0.7)),
                ),
                const SizedBox(height: 10),
                InfoRow(label: 'Description', value: admin['description']),
                const SizedBox(height: 12),
                InfoRow(label: 'Created On', value: admin['created_on'].split("T")[0]),
                InfoRow(label: 'Due Date', value: admin['due_date'].split("T")[0]),
                const SizedBox(height: 20),
                const Text(
                  "Profile Strength",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: deepTeal,
                  ),
                ),
                const SizedBox(height: 8),
                CircularPercentIndicator(
                  radius: 70.0,
                  lineWidth: 10.0,
                  percent: 0.85,
                  center: const Text(
                    "85%",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  progressColor: deepTeal,
                  backgroundColor: Colors.grey[300]!,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => _launchURL('https://linkedin.com/in/${admin['name']}'),
                      icon: const FaIcon(FontAwesomeIcons.linkedin, color: Color(0xFF0A66C2)),
                      tooltip: 'LinkedIn',
                    ),
                    IconButton(
                      onPressed: () => _launchURL('https://github.com/${admin['name']}'),
                      icon: const FaIcon(FontAwesomeIcons.github, color: Colors.black),
                      tooltip: 'GitHub',
                    ),
                    IconButton(
                      onPressed: () => _launchURL('https://instagram.com/${admin['name']}'),
                      icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
                      tooltip: 'Instagram',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
