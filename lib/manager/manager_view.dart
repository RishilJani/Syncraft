import 'package:intl/intl.dart';
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
      tasks: [
        ManagerTask(id: "task1", title: "Simple task with attachment", description: "description", assignedTo: "Alice", status: "in progress", priority: "Low", deadline: DateTime.now().add(const Duration(days: 5)),comments: [], attachments: [
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
          'https://via.placeholder.com/150.png'
        ],)
      ],
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
          title: const Text('Add Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title', border: inputBorder),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description', border: inputBorder),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  value: assignedTo,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: 'Assign To', border: inputBorder),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text("Unassigned (Visible to All)")),
                    ...project.teamMembers.map(
                            (member) => DropdownMenuItem<String?>(value: member, child: Text(member))),
                  ],
                  onChanged: (value) => setModalState(() => assignedTo = value),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(labelText: 'Priority', border: inputBorder),
                  items: priorityOptions
                      .map((priority) => DropdownMenuItem<String>(value: priority, child: Text(priority)))
                      .toList(),
                  onChanged: (value) => setModalState(() => selectedPriority = value),
                ),
                const SizedBox(height: 10),
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
                      icon: const Icon(Icons.calendar_today),
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
              child: const Text('Add'),
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
          title: const Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title', border: inputBorder),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description', border: inputBorder),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  value: assignedTo,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: 'Assign To', border: inputBorder),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text("Unassigned (Visible to All)")),
                    ...project.teamMembers.map((member) => DropdownMenuItem<String?>(value: member, child: Text(member))),
                  ],
                  onChanged: (value) => setModalState(() => assignedTo = value),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(labelText: 'Priority', border: inputBorder),
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                      .toList(),
                  onChanged: (value) => setModalState(() => selectedPriority = value!),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Deadline: ${DateFormat('dd-MM-yyyy').format(selectedDeadline)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDeadline,
                          firstDate: DateTime.now().subtract(const Duration(days: 1)),
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
              child: const Text('Save'),
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          '$label ($count)',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSection(String title, List<ManagerTask> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.deepPurple),
        ),
        const SizedBox(height: 8),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("No tasks available", style: TextStyle(color: Colors.grey[600])),
          )
        else
          ...tasks.map((task) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded content (Title, Description, etc.)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _editTaskDialog(task),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(task.description),
                              Text('Assigned to: ${task.assignedTo.isEmpty ? "Overall" : task.assignedTo}'),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Due: ${DateFormat('dd-MM-yyyy').format(task.deadline)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: task.deadline.isBefore(DateTime.now()) ? Colors.red : Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(Icons.flag, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Priority: ${task.priority}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: task.priority == 'High'
                                          ? Colors.red
                                          : task.priority == 'Medium'
                                          ? Colors.orange
                                          : Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right section: Comments and Status
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Comments",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.comment, color: Colors.deepPurple),
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
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: task.status,
                                style: const TextStyle(color: Colors.black),
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                                items: ['pending', 'in progress', 'in review', 'completed']
                                    .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
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

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.attach_file, size: 20, color: Colors.deepPurple),
                              SizedBox(width: 4),
                              Text("Attachments", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ...task.attachments.map(
                                (fileUrl) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.file_present, size: 18),
                                label: Text(fileUrl.split('/').last),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  await downloadAndOpenFile(fileUrl); // fileUrl = local or remote
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  List<ManagerTask> getTasksByStatus(String status) {
    return project.tasks.where((t) => t.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${project.managerName}!!", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        actions: [
          IconButton( onPressed: () => showLogoutDialog(context), icon: const Icon(Icons.logout,),),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(project.projectName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // LinearProgressIndicator(value: controller.getProgress(project)),
            // SizedBox(height: 8),
            // Text("Progress: ${(controller.getProgress(project) * 100).toStringAsFixed(0)}%"),
            // SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildStatCard("Total", totalTasks),
                _buildStatCard("Completed", completedTasks),
                _buildStatCard("In Progress", inProgressTasks),
                _buildStatCard("In Review", inReviewTasks),
                _buildStatCard("To Do", todoTasks),
              ],
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addTaskDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text("Add Task", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                // ElevatedButton(
                //   onPressed: (){
                //     //TODO Navigate To Project Progress Page
                //   },
                //   // onPressed: () {
                //   //   Navigator.push(context,MaterialPageRoute(
                //   //       builder: (_) => ProjectProgressPage(
                //   //         project: project,
                //   //         controller: controller,
                //   //       ),
                //   //     ),
                //   //   );
                //   // },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.deepPurple,
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //     child: Text("View Progress", style: TextStyle(color: Colors.white, fontSize: 16)),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
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

  downloadAndOpenFile(String fileUrl) {}
}