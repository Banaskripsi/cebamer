import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetCheckerHelper {
  static Future<bool> terkoneksi() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }
}