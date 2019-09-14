import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendance {
  static const String app_name = "Attendance";
  static const String app_version = "Version 1.0.0";
  static const int app_version_code = 1;
  //static const String app_color = "#ffd7167";
  //static Color primaryAppColor = Colors.white;
  //static Color secondaryAppColor = Colors.black;
  static const String google_sans_family = "GoogleSans";
  static bool isDebugMode = false;

  // * Url related
  static String baseUrl = "https://storage.googleapis.com/gdg-devfest";

  static checkDebug() {
    assert(() {
      // baseUrl = "http://127.0.0.1:8000/gdg-devfest/";
      // * Change with your local url if any
      isDebugMode = true;
      return true;
    }());
  }

  static bool get checkDebugBool {
    var debug = false;
    assert(debug = true);

    return debug;
  }

  //* Preferences
  static SharedPreferences prefs;
  static const String darkModePref = "darkModePref";
}
