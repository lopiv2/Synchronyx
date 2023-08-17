// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/models/game.dart';
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
  CategoryPlatform,
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

extension SearchParametersValueExtension on SearchParametersDropDown {
  String get caseValue {
    switch (this) {
      case SearchParametersDropDown.AddDate:
        return "addDate";
      case SearchParametersDropDown.CategoryPlatform:
        return "categoryPlatform";
      case SearchParametersDropDown.Developer:
        return "developer";
      case SearchParametersDropDown.Favorite:
        return "favorite";
      case SearchParametersDropDown.Genre:
        return "genre";
      case SearchParametersDropDown.Installed:
        return "installed";
      case SearchParametersDropDown.Lastplayed:
        return "lastPlayed";
      case SearchParametersDropDown.LaunchDate:
        return "launchDate";
      case SearchParametersDropDown.MaxPlayers:
        return "maxPlayers";
      case SearchParametersDropDown.Platform:
        return "platform";
      case SearchParametersDropDown.Playtime:
        return "playTime";
      case SearchParametersDropDown.Publisher:
        return "publisher";
      case SearchParametersDropDown.Rating:
        return "rating";
      case SearchParametersDropDown.Region:
        return "region";
      default:
        return "";
    }
  }
}

extension SearchParametersExtension on SearchParametersDropDown {
  String getLocalizedString(BuildContext context) {
    switch (this) {
      case SearchParametersDropDown.AddDate:
        return AppLocalizations.of(context).addDate;
      case SearchParametersDropDown.CategoryPlatform:
        return AppLocalizations.of(context).categoryPlatform;
      case SearchParametersDropDown.Developer:
        return AppLocalizations.of(context).developer;
      case SearchParametersDropDown.Favorite:
        return AppLocalizations.of(context).favorite;
      case SearchParametersDropDown.Genre:
        return AppLocalizations.of(context).genre;
      case SearchParametersDropDown.Installed:
        return AppLocalizations.of(context).installed;
      case SearchParametersDropDown.Lastplayed:
        return AppLocalizations.of(context).lastPlayed;
      case SearchParametersDropDown.LaunchDate:
        return AppLocalizations.of(context).launchDate;
      case SearchParametersDropDown.MaxPlayers:
        return AppLocalizations.of(context).maxPlayers;
      case SearchParametersDropDown.Platform:
        return AppLocalizations.of(context).platform;
      case SearchParametersDropDown.Playtime:
        return AppLocalizations.of(context).playTime;
      case SearchParametersDropDown.Publisher:
        return AppLocalizations.of(context).publisher;
      case SearchParametersDropDown.Rating:
        return AppLocalizations.of(context).rating;
      case SearchParametersDropDown.Region:
        return AppLocalizations.of(context).region;
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
        return "Windows";
      case Platforms.DS:
        return "Nintendo DS";
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
  static Game? selectedGame;
  static Database? database;
}
