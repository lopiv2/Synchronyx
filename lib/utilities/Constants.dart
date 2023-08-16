// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/api.dart';

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

enum SearchParametersDropDown {
  AddDate,
  Developer,
  Favorite,
  Genre,
  Installed,
  Lastplayed,
  LaunchDate,
  MaxPlayers,
  Platform,
  Playtime,
  Publisher,
  Rating,
  Region,
}

extension SearchParametersExtension on SearchParametersDropDown {
  String get value {
    switch (this) {
      case SearchParametersDropDown.AddDate:
        //return localizations?.addDate ?? 'AddDate';
        return "AddDate";
      case SearchParametersDropDown.Developer:
        return "Max Players";
      case SearchParametersDropDown.Favorite:
        return "Favorite";
      case SearchParametersDropDown.Genre:
        return "Genre";
      case SearchParametersDropDown.Installed:
        return "Installed";
      case SearchParametersDropDown.Lastplayed:
        return "Last played";
      case SearchParametersDropDown.LaunchDate:
        return "Launch Date";
      case SearchParametersDropDown.MaxPlayers:
        return "Max Players";
      case SearchParametersDropDown.Platform:
        return "Platform";
      case SearchParametersDropDown.Playtime:
        return "Playtime";
      case SearchParametersDropDown.Publisher:
        return "Publisher";
      case SearchParametersDropDown.Rating:
        return "Rating";
      case SearchParametersDropDown.Region:
        return "Region";
      default:
        return "";
    }
  }
}

enum Platforms {
  Dreamcast,
  DS,
  Gameboy,
  Gamecube,
  Gamegear,
  Linux,
  Mac,
  MAME,
  Mastersystem,
  Megadrive,
  Neogeo,
  NES,
  Nintendo64,
  PS1,
  PS2,
  PS3,
  PSP,
  SNES,
  Wii,
  WIIU,
  Windows,
  Xbox,
}

extension PlatformExtension on Platforms {
  String get value {
    switch (this) {
      case Platforms.Windows:
        return "windows";
      case Platforms.DS:
        return "ds";
      default:
        return "";
    }
  }
}

class Constants {
  static const String APP_NAME = "Synchronyx";
  static const int MAX_ITEMS = 10;
  static const double defaultPadding = 16.0;
  static const SIDE_BAR_COLOR = Color.fromARGB(255, 56, 156, 75);
  static const BACKGROUND_START_COLOR = Color.fromARGB(255, 33, 187, 115);
  static const BACKGROUND_END_COLOR = Color.fromARGB(255, 5, 148, 29);
  static List<Map<String, TextEditingController>> controllerMapList = [];
  static Api? foundApiBeforeImport;
  //Controladores de datos de los asistentes de importacion

  static Database? database;

  // Puedes agregar más variables estáticas aquí...
}
