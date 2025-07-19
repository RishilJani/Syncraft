import 'package:syncraft/utils/import_export.dart';

class DashboardController extends GetxController {
    int memberId;
    late MemberModal memberModal;
    DashboardController({required this.memberId, String? memberName, MemberProject? currentProject, String? teamName,List<MemberTask>? assignedTasks,List<TeamMember>? teamMembers}){
     memberModal = MemberModal(memberId: memberId, memberName: memberName, currentProject: currentProject?.obs, teamName: teamName, assignedTasks: assignedTasks, teamMembers: teamMembers);
    }

    get memberName=>memberModal.memberName;
    get teamName=>memberModal.teamName;
    get currentProject=>memberModal.currentProject;
    get assignedTasks => memberModal.assignedTasks;
    get teamMembers=> memberModal.teamMembers;

    set assignedTasks(assignedTasks)=> memberModal.assignedTasks = assignedTasks;
    Future<bool> getMemberDetails() async {
      return await memberModal.getMemberDetails();
    }
    Future<bool> getTeamProject() async {
      return await memberModal.getTeamProject();
    }
    Future<dynamic> getTasks() async {
      return await memberModal.getTasks();
    }
    Future<bool> getTeamMembers() async {
      return await memberModal.getTeamMembers();
    }

}