// Updated ManagerView with themed UI using deepTeal and yellowishWhite

import 'package:syncraft/utils/import_export.dart';

class ManagerView extends StatefulWidget {
  @override
  _ManagerViewState createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
  final ManagerController controller = ManagerController();
  late ManagerModel project;

  static const Color deepTeal = Color(0xFF015054);
  static const Color yellowishWhite = Color(0xFFEBF1CF);

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
      tasks: [
        ManagerTask(
          id: "task1",
          title: "Simple task with attachment",
          description: "description",
          assignedTo: "Alice",
          status: "in progress",
          priority: "Low",
          deadline: DateTime.now().add(Duration(days: 5)),
          comments: [],
          attachments: [
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
            'https://via.placeholder.com/150.png'
          ],
        )
      ],
    );
    controller.projects.add(project);
    _updateTaskCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowishWhite,
      appBar: AppBar(
        backgroundColor: deepTeal,
        title: Text(
          "Hello ${project.managerName} !",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26,color: Colors.limeAccent),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                project.projectName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: deepTeal,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard("Total", totalTasks),
                _buildStatCard("Completed", completedTasks),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard("In Progress", inProgressTasks),
                _buildStatCard("In Review", inReviewTasks),
                _buildStatCard("To Do", todoTasks),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addTaskDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepTeal,
                    foregroundColor: yellowishWhite,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text("Add Task"),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepTeal,
                    foregroundColor: yellowishWhite,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text("View Progress"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildTaskSection("In Review",
                      project.tasks.where((t) => t.status == 'in review').toList()),
                  _buildTaskSection("To-Do Tasks",
                      project.tasks.where((t) => t.status == 'pending').toList()),
                  _buildTaskSection("In Progress",
                      project.tasks.where((t) => t.status == 'in progress').toList()),
                  _buildTaskSection("Completed Tasks",
                      project.tasks.where((t) => t.status == 'completed').toList()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int count) {
    const Color backgroundColor = Color(0xFFD0EFFF); // calm soothing blue

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSection(String title, List<ManagerTask> tasks) {
    const cardColor = Color(0xFFF2FAF7); // soothing mint
    const titleColor = Color(0xFF30475E); // soft deep blue
    const accentColor = Color(0xFFB5EAEA); // soft aqua
    const borderColor = Color(0xFFDDDDDD); // neutral border

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        SizedBox(height: 12),
        if (tasks.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("No tasks available", style: TextStyle(color: Colors.grey[600])),
            ),
          )
        else
          ...tasks.map(
                (task) => Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => _editTaskDialog(task),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(task.description),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 16, color: accentColor),
                        SizedBox(width: 6),
                        Text('Assigned: ${task.assignedTo.isEmpty ? "Overall" : task.assignedTo}'),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: accentColor),
                        SizedBox(width: 6),
                        Text('Due: ${DateFormat('dd-MM-yyyy').format(task.deadline)}'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.flag, size: 16, color: accentColor),
                        SizedBox(width: 6),
                        Text(
                          'Priority: ${task.priority}',
                          style: TextStyle(
                            color: task.priority == 'High'
                                ? Colors.redAccent
                                : task.priority == 'Medium'
                                ? Colors.orange
                                : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            task.status.toUpperCase(),
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _updateTaskCounts() {
    setState(() {
      totalTasks = project.tasks.length;
      completedTasks =
          project.tasks.where((task) => task.status == 'completed').length;
      inProgressTasks =
          project.tasks.where((task) => task.status == 'in progress').length;
      inReviewTasks =
          project.tasks.where((task) => task.status == 'in review').length;
      todoTasks = project.tasks.where((task) => task.status == 'pending').length;
    });
  }

  void _addTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final priorityOptions = ['Low', 'Medium', 'High'];
    String? assignedTo;
    String? selectedPriority;
    DateTime? selectedDeadline;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('Add Task'),
          content: SingleChildScrollView(
            child: Column(
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
                    ...project.teamMembers.map(
                            (member) => DropdownMenuItem<String?>(value: member, child: Text(member))),
                  ],
                  onChanged: (value) => setModalState(() => assignedTo = value),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(labelText: 'Priority', border: inputBorder),
                  items: priorityOptions
                      .map((priority) => DropdownMenuItem<String>(value: priority, child: Text(priority)))
                      .toList(),
                  onChanged: (value) => setModalState(() => selectedPriority = value),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDeadline == null
                            ? 'No deadline chosen'
                            : 'Deadline: ${DateFormat('dd-MM-yyyy').format(selectedDeadline!)}',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedDeadline = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    selectedPriority != null &&
                    selectedDeadline != null) {
                  setState(() {
                    controller.addTask(
                      project,
                      titleController.text,
                      descriptionController.text,
                      assignedTo ?? "",
                      priority: selectedPriority!,
                      deadline: selectedDeadline!,
                    );
                    _updateTaskCounts();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            )
          ],
        ),
      ),
    );
  }

  void _editTaskDialog(ManagerTask task) async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    String? assignedTo = task.assignedTo.isEmpty ? null : task.assignedTo;
    String selectedPriority = task.priority;
    DateTime selectedDeadline = task.deadline;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
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
                  onChanged: (value) => setModalState(() => assignedTo = value),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(labelText: 'Priority', border: inputBorder),
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                      .toList(),
                  onChanged: (value) => setModalState(() => selectedPriority = value!),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Deadline: ${DateFormat('dd-MM-yyyy').format(selectedDeadline)}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDeadline,
                          firstDate: DateTime.now().subtract(Duration(days: 1)),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDeadline = picked);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  task.title = titleController.text;
                  task.description = descriptionController.text;
                  task.assignedTo = assignedTo ?? '';
                  task.priority = selectedPriority;
                  task.deadline = selectedDeadline;
                  setState(() => _updateTaskCounts());
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}