import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _latestUserName = "latestUserName";

  static setLatestUserName(userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_latestUserName, userName);
  }

  static Future<String> getLatestUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_latestUserName);
  }
}
