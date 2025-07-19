enum UserRole { admin, projectManager, teamMember }

class RegistrationController{
  bool isLogin = true;

  String email = '';
  String password = '';
  UserRole? selectedRole = UserRole.admin;
  bool rememberMe = false;

}