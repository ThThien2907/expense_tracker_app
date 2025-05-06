import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionChecker {
  Future<bool> hasInternetConnection() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }
}