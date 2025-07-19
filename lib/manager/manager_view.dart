import 'package:syncraft/utils/import_export.dart';

class ManagerView extends StatefulWidget {
  @override
  _ManagerViewState createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
  final ManagerController controller = ManagerController();
  late ManagerModel project;

  @override
  void initState() {
    super.initState();
    project = ManagerModel(
      id: '1',
      name: 'App Development',
      teamMembers: ['Alice', 'Bob', 'Charlie'],
      tasks: [],
    );
    controller.projects.add(project);
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
              decoration: InputDecoration(
                labelText: 'Title',
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String?>(
              value: assignedTo,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Assign To',
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text("Unassigned (Visible to All)"),
                ),
                ...project.teamMembers.map(
                      (member) => DropdownMenuItem<String?>(
                    value: member,
                    child: Text(member),
                  ),
                )
              ],
              onChanged: (value) {
                assignedTo = value;
              },
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                setState(() {
                  controller.addTask(
                    project,
                    titleController.text,
                    descriptionController.text,
                    assignedTo ?? "",
                  );
                });
              }
            },
            child: Text('Add'),
          )
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
      appBar: AppBar(title: Text("Manager Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(project.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            LinearProgressIndicator(value: controller.getProgress(project)),
            Text("Progress: ${(controller.getProgress(project) * 100).toStringAsFixed(0)}%"),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _addTaskDialog, child: Text("Add Task")),
            Expanded(
              child: ListView(
                children: [
                  _buildTaskSection("In Review", getTasksByStatus('in review')),
                  SizedBox(height: 16),
                  _buildTaskSection("To-Do Tasks", getTasksByStatus('pending')),
                  SizedBox(height: 16),
                  _buildTaskSection("Completed Tasks", getTasksByStatus('completed')),
                  SizedBox(height: 16),
                  _buildTaskSection("In Progress", getTasksByStatus('in progress')),
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
        ...tasks.map((task) {
          bool isExpanded = false;

          return StatefulBuilder(
            builder: (context, setInnerState) => Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () => setInnerState(() => isExpanded = !isExpanded),
                    ),
                  ),
                  if (isExpanded) ...[
                    SizedBox(height: 8),
                    Text("Assigned to: ${task.assignedTo.isEmpty ? "Overall" : task.assignedTo}"),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text("Status: "),
                        DropdownButton<String>(
                          value: task.status,
                          borderRadius: BorderRadius.circular(8),
                          items: ['pending', 'in progress', 'in review', 'completed']
                              .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.replaceAll('_', ' ')),
                          ))
                              .toList(),
                          onChanged: (newStatus) {
                            setState(() {
                              controller.updateTaskStatus(project, task.id, newStatus!);
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: controller.getTaskProgress(task),
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 5,
                    ),
                  ]
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}