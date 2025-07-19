import 'package:syncraft/utils/import_export.dart';

class TaskCommentsPage extends StatefulWidget {
  final ManagerTask task;
  final ManagerModel project;
  final ManagerController controller;

  TaskCommentsPage({
    required this.task,
    required this.project,
    required this.controller,
  });

  @override
  State<TaskCommentsPage> createState() => _TaskCommentsPageState();
}

class _TaskCommentsPageState extends State<TaskCommentsPage> {
  final commentController = TextEditingController();

  String formatDateTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final formatter = DateFormat('dd-MM-yyyy hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comments for "${widget.task.title}"')),
      body: Stack(
        children: [
          // Background image with opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/images/image3.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground content
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: widget.task.comments.isEmpty
                      ? Center(
                    child: Text(
                      "No comments yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : ListView.builder(
                    itemCount: widget.task.comments.length,
                    itemBuilder: (_, index) {
                      final commentMap = widget.task.comments[index];
                      final comment = commentMap['text'] ?? '';
                      final timestamp = commentMap['timestamp'] ?? '';
                      final user = commentMap['user'] ?? 'Unknown';
                      final initial =
                      user.isNotEmpty ? user[0].toUpperCase() : '?';

                      return ListTile(
                        tileColor: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            initial,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          comment,
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          "By $user on ${formatDateTime(timestamp)}",
                          style: TextStyle(
                              color: Colors.black87, fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            labelText: 'Add a comment',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blueAccent),
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty) {
                            final newComment = {
                              'text': commentController.text.trim(),
                              'timestamp': DateTime.now().toString(),
                              'user': widget.project.managerName,
                            };
                            widget.controller.addCommentToTask(
                              widget.project,
                              widget.task.id,
                              newComment,
                            );
                            commentController.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}