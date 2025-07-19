import 'package:get/get.dart';
import 'package:syncraft/admin/dashboard_screen.dart';
import 'package:syncraft/admin/projects/add_project_screen.dart';
import 'package:syncraft/admin/projects/project_list_screen.dart';
import 'package:syncraft/admin/teams/add_team_screen.dart';
import 'package:syncraft/admin/teams/team_list_screen.dart';



class AppPages {
  static const initial = '/dashboard';

  static final routes = [
    GetPage(name: '/dashboard', page: () => DashboardScreen()),
    GetPage(name: '/projects', page: () => ProjectListScreen()),
    GetPage(name: '/add-project', page: () => AddProjectScreen()),
    GetPage(name: '/teams', page: () => TeamListScreen()),
    GetPage(name: '/add-team', page: () => AddTeamScreen()),

  ];
}
