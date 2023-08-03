import 'dart:ui';

import 'package:sqflite_common/sqlite_api.dart';

class Constants {
  static const String appName = "Synchronyx";
  static const int maxItems = 10;
  static const double defaultPadding = 16.0;
  static var sideBarColor = Color.fromARGB(255, 56, 156, 75);
  static var backgroundStartColor = Color.fromARGB(255, 33, 187, 115);
  static var backgroundEndColor = Color.fromARGB(255, 5, 148, 29);

  static Database? database;

  // Puedes agregar más variables estáticas aquí...
}
