// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/icons/custom_icons_icons.dart';
import 'package:synchronyx/models/emulators.dart';
import '../models/api.dart';

enum PlatformStore {
  Amazon(
      Icon(CustomIcons.amazon_games, color: Colors.orange, size: 20), "amazon"),
  BattleNet(Icon(CustomIcons.amazon_games, color: Colors.blue, size: 20),
      "battlenet"),
  Epic(Icon(CustomIcons.battle_net, color: Colors.black, size: 20), "epic"),
  Gog(
      Icon(CustomIcons.gog_dot_com,
          color: Color.fromARGB(255, 84, 9, 97), size: 20),
      "gog"),
  Itch(
      Icon(CustomIcons.itch_dot_io, color: Colors.redAccent, size: 20), "itch"),
  Origin(Icon(CustomIcons.origin, color: Colors.orange, size: 20), "origin"),
  Steam(
      Icon(CustomIcons.steam, color: Color.fromARGB(255, 12, 66, 94), size: 20),
      "steam"),
  Uplay(Icon(CustomIcons.ubisoft, color: Colors.blueAccent, size: 20), "uplay"),
  Windows(Icon(CustomIcons.windows, color: Colors.blue, size: 20), "windows"),
  Xbox(
      Icon(CustomIcons.xbox,
          color: Color.fromARGB(255, 98, 219, 102), size: 20),
      "xbox");

  final Icon icon;
  final String name;
  const PlatformStore(this.icon, this.name);

  @override
  String toString() {
    super.toString();
    return "Platform Storename is: $name";
  }
}

enum SearchParametersDropDown {
  AddDate,
  All,
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
      case SearchParametersDropDown.All:
        return "all";
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
      case SearchParametersDropDown.All:
        return AppLocalizations.of(context).all;
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

enum GamePlatforms {
  All(
      Image(
        image: AssetImage("assets/icons/allPlatforms.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "All"),
  Computers(
      Image(
        image: AssetImage("assets/icons/Amstrad CPC.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Computers"),
  Dreamcast(
      Image(
        image: AssetImage("assets/icons/dreamcast.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Dreamcast"),
  DS(
      Image(
        image: AssetImage("assets/icons/ds.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "DS"),
  Gameboy(
      Image(
        image: AssetImage("assets/icons/gameboy.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Gameboy"),
  Gamecube(
      Image(
        image: AssetImage("assets/icons/gamecube.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Gamecube"),
  Gamegear(
      Image(
        image: AssetImage("assets/icons/gamegear.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Gamegear"),
  Linux(
      Image(
        image: AssetImage("assets/icons/linux.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Linux"),
  Mac(
      Image(
        image: AssetImage("assets/icons/mac.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Mac"),
  MAME(
      Image(
        image: AssetImage("assets/icons/mame.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "MAME"),
  Mastersystem(
      Image(
        image: AssetImage("assets/icons/mastersystem.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Mastersystem"),
  Megadrive(
      Image(
        image: AssetImage("assets/icons/megadrive.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Megadrive"),
  Neogeo(
      Image(
        image: AssetImage("assets/icons/neogeo.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Neogeo"),
  NES(
      Image(
        image: AssetImage("assets/icons/nes.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "NES"),
  Nintendo64(
      Image(
        image: AssetImage("assets/icons/nintendo64.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Nintendo64"),
  PS1(
      Image(
        image: AssetImage("assets/icons/ps1.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "PS1"),
  PS2(
      Image(
        image: AssetImage("assets/icons/ps2.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "PS2"),
  PS3(
      Image(
        image: AssetImage("assets/icons/ps3.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "PS3"),
  PSP(
      Image(
        image: AssetImage("assets/icons/psp.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "PSP"),
  SNES(
      Image(
        image: AssetImage("assets/icons/snes.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "SNES"),
  Wii(
      Image(
        image: AssetImage("assets/icons/wii.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Wii"),
  WIIU(
      Image(
        image: AssetImage("assets/icons/wiiu.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "WIIU"),
  Windows(
      Image(
        image: AssetImage("assets/icons/windows.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Windows"),
  Xbox(
      Image(
        image: AssetImage("assets/icons/xbox.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Xbox");

  final Image image;
  final String name;
  const GamePlatforms(this.image, this.name);

  @override
  String toString() {
    super.toString();
    return "Platform name is: $name";
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
  static Database? database;
  static double importProgress = 0.0;
  static late Directory appDocumentsDirectory;

  static List<Emulators> emulatorsList = [
  Emulators(id: 1, name: 'PCSX2', url: 'https://example.com/emulator1', systems: 'Playstation 2', icon: 'icon1.png', description: 'Description 1', installed: 0),
  Emulators(id: 2, name: 'PPSSPP', url: 'https://example.com/emulator2', systems: 'PSP', icon: 'icon2.png', description: 'Description 2', installed: 0),
  // Agrega más objetos Emulators según sea necesario
];


  static Future<void> initialize() async {
    try {
      appDocumentsDirectory = await getApplicationDocumentsDirectory();
      /*print(
          'appDocumentsDirectory initialized to: ${appDocumentsDirectory.path}');*/
    } catch (e) {
      print('Error initializing appDocumentsDirectory: $e');
    }
  }
}
