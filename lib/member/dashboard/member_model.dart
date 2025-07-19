import 'package:syncraft/utils/import_export.dart';

class MemberModal {
  int memberId;
  String? memberName;
  String? teamName;
  MemberProject? currentProject; // A member might not have a current project
  RxList<MemberTask> assignedTasks = <MemberTask>[].obs;
  RxList<TeamMember> teamMembers = <TeamMember>[].obs;

  MemberModal({required this.memberId, this.memberName, this.currentProject, this.teamName,List<MemberTask>? assignedTasks,List<TeamMember>? teamMembers}){
    this.assignedTasks = (assignedTasks??<MemberTask>[]).obs;
    this.teamMembers = (teamMembers??<TeamMember>[]).obs;
  }

  Future<bool> getMemberDetails() async {
    await Future.delayed(Duration(seconds: 1), (){
      memberName = "Harsh Parmar";
    });
    return true;
  }

  Future<bool> getTeamProject() async {
    await Future.delayed(Duration(seconds: 1), (){
      assignedTasks = [
        MemberTask(id: 1, title: "title", status: "to do"),
        MemberTask(id: 2, title: "title", status: "completed"),
        MemberTask(id: 3, title: "title", status: "completed"),
      ].obs;
      teamName = "Tech Wizards";
      currentProject = MemberProject(
        id: 1,
        name: "SynCraft",
        description: "Best app to be ever built"??"",
        dueDate: DateTime.now().add(Duration(hours: 4)),
        totalTasks: 10,
        completedTasks: 7,
      );
    });

    return true;
  }

  Future<bool> getTasks() async {
    await Future.delayed(Duration(seconds: 1), (){
      assignedTasks = [
        MemberTask(id: 1, title: "Task 1", status: "to do", priority: "low"),
        MemberTask(id: 2, title: "Task 2", status: "in progress"),
        MemberTask(id: 3, title: "Task 3", status: "completed"),
      ].obs;
    });

    return true;
  }

  Future<bool> getTeamMembers() async {
    await Future.delayed(Duration(seconds: 1), (){
        teamMembers = [
          TeamMember(id: 1, name: "Rishil Jani", role: "manager"),
          TeamMember(id: 2, name: "Karan Lukka", role: "member"),
          TeamMember(id: 3, name: "Harsh Parmar", role: "member"),
          TeamMember(id: 4, name: "Vanita Kambariya", role: "member"),
          TeamMember(id: 5, name: "Jenisa Vasani", role: "member"),
        ].obs;
    });

    return true;
  }

  static MemberModal fromMap(Map<String, dynamic> map) => MemberModal(
    memberId: map['memberId'],
    memberName: map['memberName'],
    teamName: map['teamName'],
    currentProject: map['currentProject'],
    assignedTasks: map['assignedTasks'],
    teamMembers: map['teamMembers'],
  );

  Map<String, dynamic> toMap() => {
        'memberId': memberId,
        'memberName': memberName,
        'teamName' : teamName,
        'currentProject' : currentProject,
        'assignedTasks' : assignedTasks,
        'teamMembers' : teamMembers,
      };
}