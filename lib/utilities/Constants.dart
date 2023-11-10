// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lioncade/icons/custom_icons_icons.dart';
import 'package:lioncade/models/emulators.dart';
import 'package:lioncade/utilities/app_directory_singleton.dart';
import 'package:lioncade/widgets/animation_container_logo.dart';
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
  Itch(Icon(CustomIcons.itch_dot_io, color: Colors.redAccent, size: 20),
      "itch.io"),
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
  Owned,
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
      case SearchParametersDropDown.Owned:
        return "owned";
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
      case SearchParametersDropDown.Owned:
        return AppLocalizations.of(context).ownedGame;
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

enum AnimationsDropDown {
  FadeIn,
  FadeInDown,
  FadeInDownBig,
  FadeInUp,
  FadeInUpBig,
  FadeInLeft,
  FadeInLeftBig,
  FadeInRight,
  FadeInRightBig,
  FadeOut,
  FadeOutDown,
  FadeOutDownBig,
  FadeOutUp,
  FadeOutUpBig,
  FadeOutLeft,
  FadeOutLeftBig,
  FadeOutRight,
  FadeOutRightBig,
  BounceInDown,
  BounceInUp,
  BounceInLeft,
  BounceInRight,
  ElasticIn,
  ElasticInDown,
  ElasticInUp,
  ElasticInLeft,
  ElasticInRight,
  SlideInDown,
  SlideInUp,
  SlideInLeft,
  SlideInRight,
  FlipInX,
  FlipInY,
  ZoomIn,
  ZoomOut,
  JelloIn,
  Bounce,
  Dance,
  Flash,
  Pulse,
  Roulette,
  ShakeX,
  ShakeY,
  Spin,
  SpinPerfect,
  Swing,
}

enum GamePlatforms {
  All(
      Image(
        image: AssetImage("assets/icons/allPlatforms.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "All",
      Icons.devices),
  Android(
      Image(
        image: AssetImage("assets/icons/android.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Android",
      CustomIcons.android),
  Computers(
      Image(
        image: AssetImage("assets/icons/Amstrad CPC.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Computers",
      Icons.computer),
  Dreamcast(
      Image(
        image: AssetImage("assets/icons/dreamcast.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Dreamcast",
      CustomIcons.dreamcast),
  ThreeDS(
      Image(
        image: AssetImage("assets/icons/3ds.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "DS",
      CustomIcons.nintendo3ds),
  DS(
      Image(
        image: AssetImage("assets/icons/ds.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "DS",
      CustomIcons.ds),
  Gameboy(
      Image(
        image: AssetImage("assets/icons/gameboy.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Gameboy",
      CustomIcons.game_boy),
  Gamecube(
      Image(
        image: AssetImage("assets/icons/gamecube.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Gamecube",
      CustomIcons.gamecube),
  Gamegear(
      Image(
        image: AssetImage("assets/icons/gamegear.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Gamegear",
      Icons.computer),
  Linux(
      Image(
        image: AssetImage("assets/icons/linux.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Linux",
      CustomIcons.linux),
  Mac(
      Image(
        image: AssetImage("assets/icons/mac.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Mac",
      CustomIcons.apple),
  MAME(
      Image(
        image: AssetImage("assets/icons/mame.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "MAME",
      CustomIcons.mame),
  Mastersystem(
      Image(
        image: AssetImage("assets/icons/mastersystem.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Mastersystem",
      Icons.computer),
  Megadrive(
      Image(
        image: AssetImage("assets/icons/megadrive.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Megadrive",
      CustomIcons.sega_mega_drive),
  Neogeo(
      Image(
        image: AssetImage("assets/icons/neogeo.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Neogeo",
      Icons.computer),
  NES(
      Image(
        image: AssetImage("assets/icons/nes.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "NES",
      CustomIcons.nes),
  Nintendo64(
      Image(
        image: AssetImage("assets/icons/nintendo64.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Nintendo64",
      CustomIcons.nintendo_64),
  PS1(
      Image(
        image: AssetImage("assets/icons/ps1.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "PS1,Playstation 1",
      CustomIcons.ps1),
  PS2(
      Image(
        image: AssetImage("assets/icons/ps2.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "PS2,Playstation 2",
      CustomIcons.ps2),
  PS3(
      Image(
        image: AssetImage("assets/icons/ps3.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "PS3,Playstation 3",
      CustomIcons.ps3),
  PSP(
      Image(
        image: AssetImage("assets/icons/psp.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "PSP",
      CustomIcons.psp),
  SNES(
      Image(
        image: AssetImage("assets/icons/snes.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "SNES",
      CustomIcons.snes),
  Wii(
      Image(
        image: AssetImage("assets/icons/wii.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Wii",
      CustomIcons.wii),
  WIIU(
      Image(
        image: AssetImage("assets/icons/wiiu.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "WIIU",
      CustomIcons.wii_u),
  Windows(
      Image(
        image: AssetImage("assets/icons/windows.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Windows",
      CustomIcons.windows),
  Xbox(
      Image(
        image: AssetImage("assets/icons/xbox.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Xbox",
      CustomIcons.xbox),
  XboxOne(
      Image(
        image: AssetImage("assets/icons/xboxone.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Xbox",
      CustomIcons.xbox),
  XboxSeriesX(
      Image(
        image: AssetImage("assets/icons/xboxseriesx.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Xbox",
      CustomIcons.xbox),
  Xbox360(
      Image(
        image: AssetImage("assets/icons/xbox360.png"),
        width: 34,
        height: 34,
        color: null,
      ),
      "Xbox",
      CustomIcons.xbox);

  final Image image;
  final String name;
  final IconData icon;
  const GamePlatforms(this.image, this.name, this.icon);

  @override
  String toString() {
    super.toString();
    return "Platform name is: $name";
  }
}

class Constants {
  static const String APP_NAME = "Lioncade";
  static const int MAX_ITEMS = 10;
  static const double defaultPadding = 16.0;
  static const SIDE_BAR_COLOR = Color.fromARGB(255, 56, 156, 75);
  static const BACKGROUND_START_COLOR = Color.fromARGB(255, 33, 187, 115);
  static const BACKGROUND_END_COLOR = Color.fromARGB(255, 5, 148, 29);
  static List<Map<String, TextEditingController>> controllerMapList = [];
  static Api? foundApiBeforeImport;
  static Database? database;

  static List<Emulators> emulatorsList = [
    Emulators(
        id: 1,
        name: 'PCSX2',
        url: 'https://example.com/emulator1',
        systems: 'Playstation 2',
        icon: 'icons/PCSX2.png',
        description: 'Description 1',
        installed: 0),
    Emulators(
        id: 2,
        name: 'PPSSPP',
        url: 'https://example.com/emulator2',
        systems: 'PSP',
        icon: 'icons/PPSSPP.png',
        description: 'Description 2',
        installed: 0),
    Emulators(
        id: 3,
        name: 'Flycast',
        url: 'https://example.com/emulator1',
        systems: 'Dreamcast',
        icon: 'icons/flycast.png',
        description: 'Description 1',
        installed: 0),
    Emulators(
        id: 4,
        name: 'Redream',
        url: 'https://redream.io/download',
        systems: 'Dreamcast',
        icon: 'icons/redream.png',
        description: 'Description 2',
        installed: 0),
    Emulators(
        id: 5,
        name: 'Dolphin',
        url: 'https://es.dolphin-emu.org/download/',
        systems: 'WII,GameCube',
        icon: 'icons/dolphin.png',
        description: 'Description 3',
        installed: 0),
    Emulators(
        id: 6,
        name: 'SNES9X',
        url:
            'https://dl.emulator-zone.com/download.php/emulators/snes/snes9x/snes9x-1.62.3-win32-x64.zip',
        systems: 'SNES',
        icon: 'icons/snes9x.png',
        description: 'Description 3',
        installed: 0),
    Emulators(
        id: 7,
        name: 'BSNES',
        url: 'https://bsnes.org/download/',
        systems: 'SNES',
        icon: 'icons/bsnes.png',
        description: 'Description 3',
        installed: 0),
  ];

  static Map<String, Widget Function(AnimationController)> animationWidgets = {
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeInDown': (_controller) {
      return FadeInDown(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeInDownBig': (_controller) {
      return FadeInDownBig(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeInLeft': (_controller) {
      return FadeInLeft(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeInLeftBig': (_controller) {
      return FadeInLeftBig(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeInUpBig': (_controller) {
      return FadeInUpBig(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeInRight': (_controller) {
      return FadeInRight(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeInRightBig': (_controller) {
      return FadeInRightBig(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOut': (_controller) {
      return FadeOut(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOutDown': (_controller) {
      return FadeOutDown(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOutDownBig': (_controller) {
      return FadeOutDownBig(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOutUp': (_controller) {
      return FadeOutUp(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOutUpBig': (_controller) {
      return FadeOutUpBig(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOutLeft': (_controller) {
      return FadeOutLeft(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOutLeftBig': (_controller) {
      return FadeOutLeftBig(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOutRight': (_controller) {
      return FadeOutRight(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FadeOutRightBig': (_controller) {
      return FadeOutRightBig(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'BounceInDown': (_controller) {
      return BounceInDown(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'BounceInUp': (_controller) {
      return BounceInUp(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'BounceInLeft': (_controller) {
      return BounceInLeft(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'BounceInRight': (_controller) {
      return BounceInRight(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ElasticIn': (_controller) {
      return ElasticIn(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ElasticInDown': (_controller) {
      return ElasticInDown(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ElasticInUp': (_controller) {
      return ElasticInUp(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ElasticInLeft': (_controller) {
      return ElasticInLeft(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ElasticInRight': (_controller) {
      return ElasticInRight(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'SlideInDown': (_controller) {
      return SlideInDown(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'SlideInUp': (_controller) {
      return SlideInUp(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'SlideInLeft': (_controller) {
      return SlideInLeft(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'SlideInRight': (_controller) {
      return SlideInRight(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FlipInX': (_controller) {
      return FlipInX(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'FlipInY': (_controller) {
      return FlipInY(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ZoomIn': (_controller) {
      return ZoomIn(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ZoomOut': (_controller) {
      return ZoomOut(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'JelloIn': (_controller) {
      return JelloIn(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'Bounce': (_controller) {
      return Bounce(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'Dance': (_controller) {
      return Dance(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'Flash': (_controller) {
      return Flash(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'Pulse': (_controller) {
      return Pulse(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'Roulette': (_controller) {
      return Roulette(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ShakeX': (_controller) {
      return ShakeX(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'ShakeY': (_controller) {
      return ShakeY(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'Spin': (_controller) {
      return Spin(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'SpinPerfect': (_controller) {
      return SpinPerfect(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
    // ignore: no_leading_underscores_for_local_identifiers
    'Swing': (_controller) {
      return Swing(
        controller: (controller) => _controller = controller,
        duration: const Duration(seconds: 2),
        child: const AnimationLogoContainer(),
      );
    },
  };
}
