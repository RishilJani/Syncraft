import 'package:syncraft/utils/import_export.dart';

class ProfileCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/image2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Centered profile card
          Center(
            child: ProfileCard(),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name = 'Alice Kumar';
  final String role = 'Project Lead';
  final String email = 'alice@pmtool.com';
  final int totalTasks = 10;
  final int tasksDone = 8;

  @override
  Widget build(BuildContext context) {
    int tasksLeft = totalTasks - tasksDone;
    double progress = tasksDone / totalTasks;

    return Container(
      width: 340,
      padding: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.lime[50],
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with gradient and profile image
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/images/image1.png"),
                ),
              ),
            ],
          ),
          SizedBox(height: 48),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(role, style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 10),
                InfoRow(label: 'Email', value: email),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: InfoRow(label: 'Tasks Done', value: '$tasksDone')),
                    SizedBox(width: 10),
                    Expanded(child: InfoRow(label: 'Tasks Left', value: '$tasksLeft')),
                  ],
                ),
                SizedBox(height: 20),
                Text("Progress", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                CircularPercentIndicator(
                  radius: 70.0,
                  lineWidth: 10.0,
                  percent: progress,
                  center: Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  progressColor: Colors.indigo,
                  backgroundColor: Colors.grey[300]!,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => _launchURL('https://linkedin.com/in/$name'),
                      icon: FaIcon(FontAwesomeIcons.linkedin, color: Colors.blue[800]),
                    ),
                    IconButton(
                      onPressed: () => _launchURL('https://twitter.com/$name'),
                      icon: FaIcon(FontAwesomeIcons.twitter, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => _launchURL('https://instagram.com/$name'),
                      icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
                    ),
                    IconButton(
                      onPressed: () => _launchURL('https://facebook.com/$name'),
                      icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blueAccent),
                    ),
                    IconButton(
                      onPressed: () => _launchURL('https://github.com/$name'),
                      icon: FaIcon(FontAwesomeIcons.github, color: Colors.black),
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
        SizedBox(width: 8),
        Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 6),
        Expanded(
          child: Text(value, style: TextStyle(color: Colors.grey[700]), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}