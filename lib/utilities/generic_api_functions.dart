import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronyx/models/media.dart';
import 'package:synchronyx/utilities/constants.dart';
import '../models/game.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    // ignore: library_prefixes
    as databaseFunctions;
import 'generic_functions.dart';

/* -------------------------------------------------------------------------- */
/*                                API Functions                               */
/* -------------------------------------------------------------------------- */
class DioClient {
  final Dio _dio = Dio();

  final _steamApiUrl =
      'https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=';

  final _giantBombApiUrl = 'http://www.giantbomb.com/api/search/?api_key=';

  final _steamGridDBApiUrl = 'https://www.steamgriddb.com/api/v2/';

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
      String icon = game['img_icon_url'];
      String iconUrl =
          'http://media.steampowered.com/steamcommunity/public/images/apps/$appId/$icon.jpg';
      //We import by default from SteamGridDB, for the moment, the following images
      String imageFrontUrl =
          await getAndImportSteamGridDBMediaBySteamIdAndPlatform(
              key: 'fa61b6d47dfe3b6ab65a516b1f8bd0a3',
              steamId: '$appId',
              platform: 'steam');
      List<String> parts = imageFrontUrl.split('/');
      String lastPartFile = parts.last;
      String imageName = '${generateRandomAlphanumeric()}_$lastPartFile';
      String imageFolder = '\\Synchronyx\\media\\frontCovers\\';
      Media? mediaInfo = await databaseFunctions.getMediaByName(name);
      //Delete file before download a new one
      deleteFile(mediaInfo!.coverImageUrl);
      downloadAndSaveImage(imageFrontUrl, imageName, imageFolder);
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String finalImageFolder =
          '${appDocumentsDirectory.path}$imageFolder$imageName';
      //print(finalImageFolder);
      var mediaInsert =
          Media(iconUrl: iconUrl, name: name, coverImageUrl: finalImageFolder);
      await databaseFunctions.insertMedia(mediaInsert);
      List<String> tag = List.empty(growable: true);
      tag.add("prueba");
      tag.add("adios");
      var gameInsert = Game(
          title: name,
          playTime: playtime,
          platform: Platforms.Windows.value,
          mediaId: mediaInfo!.id,
          tags: tag.join(','));
      await databaseFunctions.insertGame(gameInsert);

      break;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                             Scrappers for Media                            */
  /* -------------------------------------------------------------------------- */

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

      //print('$game');

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

  /* ----------------------------- Get SteamGridDB Media by Steam App Id and Platform ---------------------------- */
  Future<String> getAndImportSteamGridDBMediaBySteamIdAndPlatform(
      {required String key,
      required String steamId,
      required String platform}) async {
    // Definir los encabezados que deseas enviar
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $key',
      'Content-Type': 'application/json',
    };
    Response userData = await _dio.get(
        _steamGridDBApiUrl + 'grids/$platform/$steamId',
        options: Options(headers: headers));
    String jsonData = jsonEncode(userData.data);
    //print('Game Data: $jsonData');

    Map<String, dynamic> responseData = userData.data;
    // Obtener la lista "data"
    List<dynamic> dataList = responseData['data'];

    if (dataList.isNotEmpty) {
      // Obtener el primer elemento de la lista
      Map<String, dynamic> firstData = dataList[0];

      // Obtener el valor del campo "url"
      String imageUrl = firstData['url'];

      //Returns the value of the first image obtained.
      return imageUrl;
    }
    return '';
  }
}
