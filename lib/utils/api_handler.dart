import 'package:syncraft/utils/import_export.dart';
import 'package:http/http.dart' as http;

class APIHandler {
  static final APIHandler _instance = APIHandler._internal();
  factory APIHandler() => _instance; // creates sprcial constructor for singleTon class

  APIHandler._internal();
  Duration timeout = Duration(seconds: 10);

  Future<dynamic> getMemberDetails({required int memberId,context}) async {
    // showProgressDialog(context);
    http.Response res = await http.get(Uri.parse(BASE_URL)).timeout(timeout);
    // dismissProgress();
    return convertJSONToData(res);
  }
  Future<dynamic> getTeamName({required int memberId,context}) async {
    // showProgressDialog(context);
    print("-----------");
    http.Response res = await http.get(Uri.parse('$baseUrl/teams/by-member/$memberId'));
    print("$res-----------");
    // dismissProgress();
    return convertJSONToData(res);
  }
  Future<dynamic> getTasks({required int memberId,context}) async {
    // showProgressDialog(context);
    http.Response res = await http.get(Uri.parse('$baseUrl/tasks/user/$memberId')).timeout(timeout);
    // dismissProgress();
    return convertJSONToData(res);
  }

  Future<dynamic> getTeamProject({required int memberId,context}) async {
    // showProgressDialog(context);
    http.Response res = await http.get(Uri.parse('$baseUrl/projects/by-member/$memberId')).timeout(timeout);
    // dismissProgress();
    return convertJSONToData(res);
  }

  Future<dynamic> getTeamMembers({required int memberId,context}) async {
    // showProgressDialog(context);
    http.Response res = await http.post(Uri.parse('$baseUrl/teams/by-member/$memberId'));
    // dismissProgress();
    return convertJSONToData(res);
  }

  // Future<dynamic> updateUser({id, map, context}) async {
  //   // showProgressDialog(context);
  //   http.Response res =
  //   await http.put(Uri.parse(baseUrl + '$/$id'), body: map);
  //   // dismissProgress();
  //   return convertJSONToData(res);
  // }
  //
  // Future<dynamic> deleteUser({id, context}) async {
  //   // showProgressDialog(context);
  //   http.Response res = await http.delete(Uri.parse(baseUrl + '$DBNAME/$id'));
  //   // dismissProgress();
  //   return convertJSONToData(res);
  // }
  // Future<dynamic> deleteAllUsers({context}) async {
  //   // showProgressDialog(context);
  //   http.Response res = await http.delete(Uri.parse(baseUrl + '$DBNAME'));
  //   // dismissProgress();
  //   return convertJSONToData(res);
  // }

  Future<Map<String,dynamic>> getLoginData(Map<String,dynamic> mp) async {
    var res = await http.post(
      Uri.parse("$BASE_URL/users/login"),
      body: jsonEncode(mp),
      headers: {"Content-Type": "application/json"},
    );
    if(res.statusCode == 200){
      var response = jsonDecode(res.body);
      if(response["isFound"]){
        mp["id"] = response["id"];
      }
    }
    return mp;
  }

  Future<Map<String,dynamic>> getSignUpData(Map<String,dynamic> mp) async{
    Map<String,dynamic> mapID = {};
    var res = await http.post(
        Uri.parse("$BASE_URL/users/"),
      body: jsonEncode(mp),
      headers: {"Content-Type": "application/json"},
    );
    if(res.statusCode == 200){
      var response = jsonDecode(res.body);
      mapID["id"] = response["id"];
      return mapID;
    }
    return mapID;
  }

  Future<void> getTasksForManager({required managerID}) async{
    dynamic data = await getTeamProject(memberId: managerID);
    if(data == "ERROR"){
      return;
    }

  }

  dynamic convertJSONToData(http.Response res) {
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    else {
      return 'ERROR';
    }
  }
}