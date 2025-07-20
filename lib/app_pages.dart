import 'package:syncraft/utils/import_export.dart';

class AppPages {
  static const initial = RT_LOGIN_REGISTRATION_PAGE;

  static final routes = [
    GetPage(
        name: RT_LOGIN_REGISTRATION_PAGE,
        page: () => const LoginRegisterPage(),
    ),
    GetPage(
        name: RT_SIGNUP, page: () => RegistrationPage()
    ),

    // admin
    GetPage(
      name: RT_ADMIN_DASHBOARD,
      page: () => const DashboardScreen(),
    ),
    GetPage(name: RT_ADMIN_ADD_PROJECTS, page: () => AddProjectScreen()),
    GetPage(name: RT_ADMIN_TEAMS, page: () => TeamListScreen()),
    GetPage(name: RT_ADMIN_ADD_TEAM, page: () => AddTeamScreen()),

    // manager
    GetPage(
        name: RT_MANAGER_DASHBOARD,
        page: () => const ManagerView()
    ),

    // member
    GetPage(
        name: RT_MEMBER_DASHBOARD,
        page: () => MemberDashboardView(),
    ),

    // GetPage(name: '/projects', page: () => ProjectListScreen()),
  ];
}
