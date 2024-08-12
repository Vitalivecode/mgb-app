import 'package:flutter/material.dart';

class AppConstants {
  static String baseUrl = "";

  AppConstants._();

  static final GlobalKey<ScaffoldMessengerState> globalScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static const login = 'login_token';
}
