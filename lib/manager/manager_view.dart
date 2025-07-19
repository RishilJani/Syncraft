import 'package:syncraft/utils/import_export.dart';

class ManagerView extends StatefulWidget {
  @override
  _ManagerViewState createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
  final ManagerController controller = ManagerController();
  late ManagerModel project;

  int totalTasks = 0;
  int completedTasks = 0;
  int inProgressTasks = 0;
  int inReviewTasks = 0;
  int todoTasks = 0;

  @override
  void initState() {
    super.initState();
    project = ManagerModel(
      id: '1',
      managerName: 'Karan',
      projectName: 'SIGN UP FORM',
      teamMembers: ['Alice', 'Bob', 'Charlie'],
      tasks: [],
    );
    controller.projects.add(project);
    _updateTaskCounts();
  }

  void _updateTaskCounts() {
    setState(() {
      totalTasks = project.tasks.length;
      completedTasks = project.tasks.where((task) => task.status == 'completed').length;
      inProgressTasks = project.tasks.where((task) => task.status == 'in progress').length;
      inReviewTasks = project.tasks.where((task) => task.status == 'in review').length;
      todoTasks = project.tasks.where((task) => task.status == 'pending').length;
    });
  }

  void _addTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? assignedTo;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title', border: inputBorder),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description', border: inputBorder),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String?>(
              value: assignedTo,
              isExpanded: true,
              decoration: InputDecoration(labelText: 'Assign To', border: inputBorder),
              items: [
                DropdownMenuItem<String?>(value: null, child: Text("Unassigned (Visible to All)")),
                ...project.teamMembers.map((member) => DropdownMenuItem<String?>(value: member, child: Text(member))),
              ],
              onChanged: (value) => assignedTo = value,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                controller.addTask(
                  project,
                  titleController.text,
                  descriptionController.text,
                  assignedTo ?? "",
                );
                _updateTaskCounts();
              }
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }

  void _editTaskDialog(ManagerTask task) async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    String? assignedTo = task.assignedTo.isEmpty ? null : task.assignedTo;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title', border: inputBorder),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description', border: inputBorder),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String?>(
              value: assignedTo,
              isExpanded: true,
              decoration: InputDecoration(labelText: 'Assign To', border: inputBorder),
              items: [
                DropdownMenuItem<String?>(value: null, child: Text("Unassigned (Visible to All)")),
                ...project.teamMembers.map((member) => DropdownMenuItem<String?>(value: member, child: Text(member))),
              ],
              onChanged: (value) => assignedTo = value,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                controller.updateTaskDetails(
                  project,
                  task.id,
                  titleController.text,
                  descriptionController.text,
                  assignedTo ?? "",
                );
                _updateTaskCounts();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  List<ManagerTask> getTasksByStatus(String status) {
    return project.tasks.where((t) => t.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${project.managerName}!!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(project.projectName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            LinearProgressIndicator(value: controller.getProgress(project)),
            SizedBox(height: 8),
            Text("Progress: ${(controller.getProgress(project) * 100).toStringAsFixed(0)}%"),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total: $totalTasks   "),
                Text("Completed: $completedTasks"),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("In Progress: $inProgressTasks   "),
                Text("In Review: $inReviewTasks   "),
                Text("To Do: $todoTasks"),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTaskDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text("Add Task", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildTaskSection("In Review", getTasksByStatus('in review')),
                  _buildTaskSection("To-Do Tasks", getTasksByStatus('pending')),
                  _buildTaskSection("In Progress", getTasksByStatus('in progress')),
                  _buildTaskSection("Completed Tasks", getTasksByStatus('completed')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection(String title, List<ManagerTask> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("No tasks available", style: TextStyle(color: Colors.grey[600])),
          )
        else
          ...tasks.map((task) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(task.title),
                    subtitle: Text('${task.description}\nAssigned to: ${task.assignedTo.isEmpty ? "Overall" : task.assignedTo}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.comment),
                          tooltip: 'View Comments',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskCommentsPage(
                                  task: task,
                                  project: project,
                                  controller: controller,
                                ),
                              ),
                            ).then((_) => _updateTaskCounts());
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: task.status,
                              style: TextStyle(color: Colors.black),
                              icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                              items: ['pending', 'in progress', 'in review', 'completed']
                                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                                  .toList(),
                              onChanged: (newStatus) {
                                controller.updateTaskStatus(project, task.id, newStatus!);
                                _updateTaskCounts();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _editTaskDialog(task),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}