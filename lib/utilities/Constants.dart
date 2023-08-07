// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

enum PlatformStore {
  Amazon,
  BattleNet,
  Epic,
  Gog,
  Itch,
  Origin,
  Steam,
  Uplay,
  Windows,
  Xbox,
}

class Constants {
  static const String APP_NAME = "Synchronyx";
  static const int MAX_ITEMS = 10;
  static const double defaultPadding = 16.0;
  static const SIDE_BAR_COLOR = Color.fromARGB(255, 56, 156, 75);
  static const BACKGROUND_START_COLOR = Color.fromARGB(255, 33, 187, 115);
  static const BACKGROUND_END_COLOR = Color.fromARGB(255, 5, 148, 29);
  static List<Map<String, TextEditingController>> controllerMapList = [];
 //Controladores de datos de los asistentes de importacion

  static Database? database;

  // Puedes agregar más variables estáticas aquí...
}
