import 'package:syncraft/utils/import_export.dart';

class AppPages {
  static const initial = RT_LOGIN_REGISTRATION_PAGE;

  static final routes = [
    GetPage(
        name: RT_LOGIN_REGISTRATION_PAGE,
        page: () => const LoginRegisterPage(),
    ),
    GetPage(
        name: RT_SIGNUP, page: () => const RegistrationPage()
    ),


    // admin
    GetPage( name: RT_ADMIN_DASHBOARD, page: () => const DashboardScreen(), ),
    GetPage(name: RT_ADMIN_ADD_PROJECTS, page: () => const AddProjectScreen()),
    GetPage(name: RT_ADMIN_TEAMS, page: () => TeamListScreen()),
    GetPage(name: RT_ADMIN_PROJECTS, page: () => ProjectListScreen()),
    GetPage(name: RT_ADMIN_ADD_TEAM, page: () => const AddTeamScreen()),

    // manager
    GetPage(
        name: RT_MANAGER_DASHBOARD,
        page: () => ManagerView()
    ),

    // member
    GetPage(
        name: RT_MEMBER_DASHBOARD,
        page: () => MemberDashboardView(memberId: 1,memberName: "Rishil",),
    ),

    // GetPage(name: '/projects', page: () => ProjectListScreen()),
  ];
}
