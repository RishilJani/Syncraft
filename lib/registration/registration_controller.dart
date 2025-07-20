import 'package:syncraft/utils/string_constants.dart';
enum UserRole { admin, projectManager, teamMember }

class RegistrationController {
  bool isLogin = true;

  String? username = '';
  String? email = '';
  String? password = '';
  UserRole? selectedRole = UserRole.admin;
  bool rememberMe = false;

  String? adminID = '';
  RegistrationController({this.username, this.email,this.selectedRole, this.password, this.adminID});

  Map<String,dynamic> toMap(){
    return {
      USER_NAME : username,
      USER_EMAIL : email,
      USER_ROLE : selectedRole,
      USER_PASSWORD : password,
      ADMIN_ID : adminID
    };
  }
}
