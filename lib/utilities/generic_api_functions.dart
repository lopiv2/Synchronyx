import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:synchronyx/models/media.dart';
import 'package:synchronyx/utilities/constants.dart';
import '../models/game.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as databaseFunctions;

/* -------------------------------------------------------------------------- */
/*                                API Functions                               */
/* -------------------------------------------------------------------------- */
class DioClient {
  final Dio _dio = Dio();

  final _steamApiUrl =
      'https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=';

  final _giantBombApiUrl = 'http://www.giantbomb.com/api/search/?api_key=';

/* ----------------------------- Get Steam Games ---------------------------- */
  Future<void> getAndImportSteamGames(
      {required String key, required String steamId}) async {
    Response userData = await _dio.get(
        _steamApiUrl + '$key&steamid=$steamId&format=json&include_appinfo=1');
    String jsonData = jsonEncode(userData.data);
    //print('User Info Data: $jsonData');

    Map<String, dynamic> responseData = userData.data;
    List<dynamic> gamesList = responseData['response']['games'];

    for (var game in gamesList) {
      //print(game);
      int appId = game['appid'];
      String name = game['name'];
      int playtime = game['playtime_forever'];
      String icon=game['img_icon_url'];
      String iconUrl= 'http://media.steampowered.com/steamcommunity/public/images/apps/$appId/$icon.jpg';

      //print(iconUrl);
      var mediaInsert=Media(iconUrl: iconUrl ,name: name);
      await databaseFunctions.insertMedia(mediaInsert);
      Media? mediaInfo=await databaseFunctions.getMediaByName(name);

      //print(mediaInfo!.id);
      //var mediaInsert=new Media(coverImageUrl: ,backImageUrl: ,diskImageUrl: ,videoUrl: ,iconUrl: )
      List<String> tag=List.empty(growable: true);
      tag.add("prueba");
      tag.add("adios");
      var gameInsert = Game(title: name, playTime: playtime, mediaId: mediaInfo!.id, tags: tag.join(','));
      await databaseFunctions.insertGame(gameInsert);
      break;
    }
  }

  /* --------------------------- Get GiantBomb Media -------------------------- */
  Future<void> getAndImportGiantBombMedia(
      {required String apiKey, required String query}) async {
    // API KEY: 60c9f9c89861e3fb57db954a789641081fbc2b6c
    //String _giantBombApiUrl='http://www.giantbomb.com/api/search/?api_key=[YOUR-KEY]&format=json&query="metroid prime"&resources=game';
    Response userData = await _dio.get(
        _giantBombApiUrl + '$apiKey&format=json&query=$query&&resources=game');
    String jsonData = jsonEncode(userData.data);
    //print('User Info Data: $jsonData');

    Map<String, dynamic> responseData = userData.data;
    List<dynamic> gamesList = responseData['response']['games'];

    for (var game in gamesList) {
      int appId = game['appid'];
      String name = game['name'];
      int playtime = game['playtime_forever'];
      String iconUrl = game['img_icon_url'];

      print('$game');

      /*print('Game ID: $appId');
      print('Game Name: $name');
      print('Playtime: $playtime minutes');
      print('---');*/
      //var mediaInsert=new Media(coverImageUrl: ,backImageUrl: ,diskImageUrl: ,videoUrl: ,iconUrl: )
      //var gameInsert=new Game(title: name, description: description, lastPlayed: lastPlayed)
      //databaseFunctions.insertGame(gameInsert);
      break;
    }
  }
}
