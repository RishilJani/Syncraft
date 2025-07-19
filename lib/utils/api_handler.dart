import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncraft/utils/string_constants.dart';

class APIHandler {
  static final APIHandler _instance = APIHandler._internal();
  factory APIHandler() => _instance; // creates sprcial constructor for singleTon class
  APIHandler._internal();
  Duration timeout = Duration(seconds: 5);

  Future<dynamic> getUsers({context}) async {
    // showProgressDialog(context);
    http.Response res = await http.get(Uri.parse(baseUrl)).timeout(timeout);
    // dismissProgress();
    return convertJSONToData(res);
  }

  Future<dynamic> addUser({context, map}) async {
    // showProgressDialog(context);
    http.Response res = await http.post(Uri.parse(baseUrl), body: map);
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

  dynamic convertJSONToData(http.Response res) {
    print("response received :: ${jsonDecode(res.body)}");
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else if (res.statusCode == 404) {
      return 'PAGE NOT FOUND PLEASE CHECK YOUR URL';
    } else if (res.statusCode == 500) {
      return 'SERVER UDI GAYELU 6';
    } else {
      return 'NO DATA FOUND';
    }
  }
}