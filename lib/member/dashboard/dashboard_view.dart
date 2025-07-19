import 'package:syncraft/member/dashboard/dashboard_controller.dart';
import 'package:syncraft/utils/import_export.dart';
// --- Data Models (Replace with your actual models) ---

class MemberDashboardView extends StatelessWidget {
  final int memberId;
  final String? memberName;

  late DashboardController dashboardController;

  MemberDashboardView({
    super.key,
    required this.memberId,
    required this.memberName,
  }){
    dashboardController = DashboardController(memberId: memberId);
    Get.put(dashboardController);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA), // Light, clean background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0, // Subtle shadow
        centerTitle: true,
        title: Text(
          'Welcome, $memberName!',
          style: textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.blueGrey[700]),
            onPressed: () {
              // TODO: Handle notifications
            },
          ),
        ],
      ),
      body: ListView( // Using ListView for overall scrollability
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Team Information
          _buildTeamHeader(context),
          const SizedBox(height: 20),
          ...[
            _buildSectionTitle(context, 'Current Project'),
            _CurrentProjectCard(project: dashboardController.currentProject),
            const SizedBox(height: 24),

            // Project Task Overview
            _buildProjectTaskOverview(context),
            const SizedBox(height: 24),

            // Assigned Tasks Section
            _buildSectionTitle(context, 'Your Tasks'),

            _buildAssignedTasksList(context),
            const SizedBox(height: 24),
          ],


          // Current Team Members (Expandable)
          _buildSectionTitle(context, 'Your Team'),
          _TeamMembersExpansionTile(dashboardController),

          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildTeamHeader(BuildContext context) {
    return FutureBuilder(
        future: Future(() async {
      if(dashboardController.teamName != null)
        return true;
      return await dashboardController.getTeamProject();
    }), builder: (ctx, snapshot){

      if(snapshot.hasData && snapshot.data==true ){
        print("TEAM ${dashboardController.teamName}");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR TEAM',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.blueGrey[600],
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${dashboardController.teamName}",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E), // Dark, professional color
              ),
            ),
          ],
        );
      }
      else if(!snapshot.hasData){
        return Container(
          color: Colors.grey,
          height: 100,
          width: MediaQuery.of(ctx).size.width*0.8,
        );
      }
      return Container();
    });
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  Widget _buildProjectTaskOverview(BuildContext context) {
    return FutureBuilder(future: Future(() async {
      return await dashboardController.getTeamProject();
    }), builder: (ctx,snapshot){
      if(snapshot.hasData && dashboardController.currentProject!=null){
        int totalTasks = dashboardController.currentProject?.totalTasks??0;
        int completedTasks = dashboardController.currentProject?.completedTasks??0;
        final textTheme = Theme.of(context).textTheme;
        double progress = 0;
        if (dashboardController.currentProject!.totalTasks > 0) {
          progress = dashboardController.currentProject.completedTasks / dashboardController.currentProject.totalTasks;
        }

        return Card(
          elevation: 0,
          color: Colors.blueGrey.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Project Progress",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${dashboardController.currentProject.completedTasks} / ${dashboardController.currentProject.totalTasks} tasks completed",
                      style: textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade700),
                    ),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.blueGrey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
        );
      }
      else if (!snapshot.hasData){
        return _buildEmptyTasksState(context, "List is on the way...");
      }
      else {
        return _buildEmptyTasksState(context, "No list available");
      }
    });
  }


  Widget _buildAssignedTasksList(BuildContext context) {
    return FutureBuilder(future: Future(() async {
        return await dashboardController.getTasks();
    }), builder: (ctx,snapshot){
      if(snapshot.hasData && snapshot.data==true){
        RxList<MemberTask> tasks = dashboardController.assignedTasks;
        return ListView.builder(
          shrinkWrap: true, // Important within another scrollable
          physics: const NeverScrollableScrollPhysics(), // Delegate scrolling to parent
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _TaskListItem(task: task);
          },
        );
      }
      if(!snapshot.hasData){
        return Container(
          height: 100,
          width: MediaQuery.of(ctx).size.width*0.8,
          color: Colors.grey,
        );
      }

      return _buildEmptyTasksState(context, "You are not currently assigned to a project.");
    } );
  }

  Widget _buildEmptyTasksState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 48, color: Colors.green.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.blueGrey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentProjectCard extends StatelessWidget {
  final MemberProject? project;

  const _CurrentProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    if(project == null) return Container();
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // color: Theme.of(context).primaryColor.withOpacity(0.05), // Subtle primary color hint
      color: Colors.white54, // Subtle primary color hint
      child: InkWell(
        onTap: () {
          // TODO: Navigate to project details screen
          print('Tapped on project: ${project!.name}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project!.name,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                project!.description,
                style: textTheme.bodyMedium?.copyWith(color: Colors.blueGrey[800]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (project!.dueDate != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: Colors.blueGrey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Due: ${project!.dueDate!.toLocal().toString().split(' ')[0]}', // Simple date format
                      style: textTheme.bodySmall?.copyWith(color: Colors.blueGrey[700]),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskListItem extends StatelessWidget {
  final MemberTask task;

  const _TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    IconData statusIcon;
    Color statusColor;

    switch (task.status.toLowerCase()) {
      case 'in progress':
        statusIcon = Icons.autorenew_rounded; // Or Icons.settings_ethernet for ongoing
        statusColor = Colors.orange.shade700;
        break;
      case 'completed':
        statusIcon = Icons.check_circle_rounded;
        statusColor = Colors.green.shade600;
        break;
      case 'to do':
      default:
        statusIcon = Icons.radio_button_unchecked_rounded; // Or Icons.pending_actions
        statusColor = Colors.blueGrey.shade400;
        break;
    }

    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 28),
        title: Text(
          task.title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A2E),
            decoration: task.status.toLowerCase() == 'completed'
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: Colors.grey.shade600,
          ),
        ),
        subtitle: task.priority != null || task.taskDueDate != null
            ? Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (task.priority != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(task.priority!).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.priority!,
                    style: textTheme.bodySmall?.copyWith(
                      color: _getPriorityColor(task.priority!),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (task.priority != null && task.taskDueDate != null)
                const SizedBox(width: 8),
              if (task.taskDueDate != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event_available_outlined, size: 14, color: Colors.blueGrey[400]),
                    const SizedBox(width: 4),
                    Text(
                      task.taskDueDate!.toLocal().toString().split(' ')[0],
                      style: textTheme.bodySmall?.copyWith(color: Colors.blueGrey[600]),
                    ),
                  ],
                ),
            ],
          ),
        )
            : null,
        onTap: () {
          // TODO: Navigate to task details or allow quick actions (e.g., mark as complete)
          print('Tapped on task: ${task.title}');
        },
        trailing: Icon(Icons.chevron_right, color: Colors.blueGrey[300]),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade600;
      case 'medium':
        return Colors.amber.shade700;
      case 'low':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade500;
    }
  }
}


class _TeamMembersExpansionTile extends StatelessWidget {
  DashboardController dashboardController;
   _TeamMembersExpansionTile(this.dashboardController);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder(future: Future(() async {
      return await dashboardController.getTeamMembers();
    }), builder: (ctx,snapshot){
      if(snapshot.hasData && snapshot.data==true){
        if (dashboardController.teamMembers.isEmpty) {
          return Card(
            elevation: 0,
            color: Colors.blueGrey.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "No other members found in ${dashboardController.teamName}.",
                style: textTheme.bodyMedium?.copyWith(color: Colors.blueGrey[700]),
              ),
            ),
          );
        }

        return Card(
          elevation: 1.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias, // Ensures content respects rounded corners
          child: ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            iconColor: Theme.of(context).primaryColor,
            collapsedIconColor: Colors.blueGrey[600],
            tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              'View Team Members (${dashboardController.teamMembers.length})',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            children: (dashboardController.teamMembers as List<TeamMember>).map( (member) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : 'U',
                    style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(member.name, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text(member.role, style: textTheme.bodyMedium?.copyWith(color: Colors.blueGrey[700])),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              );
            }).toList(),
          ),
        );
      }
      else if(!snapshot.hasData){
        return Container(
          height: 100,
          width: MediaQuery.of(ctx).size.width*0.8,
          color: Colors.grey,
        );
      }
      return Container();
    });
  }
}


// --- Example Usage (in your main.dart or routing) ---
// void main() {
//   runApp(MaterialApp(
//     theme: ThemeData(
//       primaryColor: Colors.teal, // Example primary color
//       primaryColorDark: Colors.teal.shade800,
//       primaryColorLight: Colors.teal.shade100,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: Colors.teal,
//         brightness: Brightness.light,
//         background: const Color(0xFFF5F7FA),
//       ),
//       textTheme: const TextTheme(
//         headlineMedium: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
//         headlineSmall: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
//         titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//         titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
//         titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
//         bodyLarge: TextStyle(fontSize: 16.0),
//         bodyMedium: TextStyle(fontSize: 14.0),
//         bodySmall: TextStyle(fontSize: 12.0),
//         labelSmall: TextStyle(fontSize: 11.0, letterSpacing: 0.5, fontWeight: FontWeight.w500),
//       ),
//       useMaterial3: true,
//     ),
//     home: MemberDashboardView(
//       memberName: 'Alex Doe',
//       teamName: 'Alpha Squad',
//       currentProject: MemberProject(
//         id: 'proj101',
//         name: 'Project Chameleon Launch',
//         description: 'Final phase of the Q3 product release, focusing on user feedback integration.',
//         dueDate: DateTime.now().add(const Duration(days: 30)),
//         totalTasks: 25,
//         completedTasks: 10,
//       ),
//       assignedTasks: [
//         MemberTask(id: 't1', title: 'Implement user profile page', status: 'In Progress', priority: 'High', taskDueDate: DateTime.now().add(const Duration(days: 7))),
//         MemberTask(id: 't2', title: 'Fix login bug #234', status: 'To Do', priority: 'Medium', taskDueDate: DateTime.now().add(const Duration(days: 3))),
//         MemberTask(id: 't3', title: 'Write unit tests for API module', status: 'To Do', priority: 'Low'),
//         MemberTask(id: 't4', title: 'Review design mockups for dashboard', status: 'Completed'),
//       ],
//       teamMembers: [
//         TeamMember(id: 'm1', name: 'Jane Smith', role: 'Lead Developer'),
//         TeamMember(id: 'm2', name: 'Bob Johnson', role: 'UI/UX Designer'),
//         TeamMember(id: 'm3', name: 'Alice Brown', role: 'QA Engineer'),
//         TeamMember(id: 'm4', name: 'Alex Doe', role: 'Frontend Developer'), // Current user
//       ],
//     ),
//   ));
// }
