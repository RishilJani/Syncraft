import '../utils/import_export.dart';
import 'package:http/http.dart' as http;

class LoginMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    RegistrationController registrationController = Get.find();

    Map<String, dynamic> mp = {
      USER_EMAIL: registrationController.email,
      USER_PASSWORD: registrationController.password,
      USER_ROLE: registrationController.selectedRole
    };
    int id = 0;

    if (registrationController.isLogin) {
      // login code
      http.post(
        Uri.parse("$BASE_URL/login"),
        body: jsonEncode(mp),
        headers: {"Content-Type": "application/json"},
      ).then((res) {
        if(res.statusCode == 200){

        }
      },);
      if (registrationController.selectedRole == UserRole.admin) {
        // navigate to admin
      } else if (registrationController.selectedRole == UserRole.projectManager) {
        // navigate to manager
      } else {
        // navigate to member
      }
    } else {
      // signup form
      http.post(
          Uri.parse("$BASE_URL/users"),
          body: jsonEncode(mp),
          headers: {"Content-Type": "application/json"},
      ).then((res) {
        if(res.statusCode == 200){
          var respone = jsonDecode(res.body);

        }
      },);
      return const RouteSettings(name: RT_TEMP_PAGE);
    }
    return const RouteSettings(name: RT_LOGIN_REGISTRATION_PAGE);
  }
}
