import 'package:syncraft/utils/api_handler.dart';
import 'package:syncraft/utils/import_export.dart';

class MemberModal {
  int memberId;
  String? memberName;
  String? teamName;
  Rx<MemberProject>? currentProject; // A member might not have a current project
  RxList<MemberTask> assignedTasks = <MemberTask>[].obs;
  RxList<TeamMember> teamMembers = <TeamMember>[].obs;

  MemberModal({required this.memberId, this.memberName, this.currentProject, this.teamName,List<MemberTask>? assignedTasks,List<TeamMember>? teamMembers}){
    this.assignedTasks = (assignedTasks??<MemberTask>[]).obs;
    this.teamMembers = (teamMembers??<TeamMember>[]).obs;
  }

  Future<bool> getMemberDetails() async {
    // getMemberDetails
    await Future.delayed(Duration(seconds: 1), (){
      memberName = "Harsh Parmar";
    });
    return true;
  }

  Future<bool> getTeamProject() async {
    dynamic data = await APIHandler().getTeamName(memberId: memberId);
    if(data is String && data == 'ERROR'){
      print("Nothing to see");
      return false;
    }

        teamName = data['name'];
        data = await getTasks();
        if(data is String && data == 'ERROR'){
          print("Nothing to see");
          return true;
        }
        if(data is List<Map<String,dynamic>>){
          assignedTasks = data.map((e) => MemberTask.fromMap(e)).toList().obs;
        }

      currentProject = MemberProject(
        id: 1,
        name: "SynCraft",
        description: "Best app to be ever built"??"",
        dueDate: DateTime.now().add(Duration(hours: 4)),
        totalTasks: 10,
        completedTasks: 7,
      ).obs;

    return true;
  }

  Future<dynamic> getTasks() async {
    return await APIHandler().getTasks(memberId: memberId);
  }

  Future<bool> getTeamMembers() async {
    dynamic data = await APIHandler().getTeamMembers(memberId: memberId).timeout(Duration(seconds: 10), onTimeout: () {print("TIMED OUT");});
    if(data is String && data == 'ERROR'){
      return false;
    }
    teamMembers = (data as List).map((e)=>TeamMember.fromMap(e)).toList().obs;

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