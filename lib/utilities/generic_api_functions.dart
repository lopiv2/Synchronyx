import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronyx/models/media.dart';
import 'package:synchronyx/utilities/constants.dart';
import '../models/game.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    // ignore: library_prefixes
    as databaseFunctions;
import 'generic_functions.dart';

/* -------------------------------------------------------------------------- */
/*                                API Functions                               */
/* -------------------------------------------------------------------------- */
class DioClient {
  final Dio _dio = Dio(BaseOptions(followRedirects: true));

  final _steamApiUrl =
      'https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=';

  final _giantBombApiUrl = 'http://www.giantbomb.com/api/search/?api_key=';

  final _steamGridDBApiUrl = 'https://www.steamgriddb.com/api/v2/';

  var IgdbAccessToken;

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
      int appId = game['appid'];
      String name = game['name'];
      int playtime = game['playtime_forever'];
      String icon = game['img_icon_url'];
      String iconUrl =
          'http://media.steampowered.com/steamcommunity/public/images/apps/$appId/$icon.jpg';
      //We import by default from SteamGridDB, cover image
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

      //We import by default from SteamGridDB, marquee image
      String marqueeFrontUrl =
          await getAndImportSteamGridDBHeroesBySteamIdAndPlatform(
              key: 'fa61b6d47dfe3b6ab65a516b1f8bd0a3',
              steamId: '$appId',
              platform: 'steam');
      List<String> marqueeParts = marqueeFrontUrl.split('/');
      String lastPartMarqueeFile = marqueeParts.last;
      String marqueeName =
          '${generateRandomAlphanumeric()}_$lastPartMarqueeFile';
      String marqueeFolder = '\\Synchronyx\\media\\marquees\\';
      //Delete file before download a new one
      deleteFile(mediaInfo!.marqueeUrl);
      downloadAndSaveImage(marqueeFrontUrl, marqueeName, marqueeFolder);
      String finalmarqueeFolder =
          '${appDocumentsDirectory.path}$marqueeFolder$marqueeName';

      //Get video for Media insert
      String videoUrl = await searchVideosAndReturnUrl('$name trailer');
      var mediaInsert = Media(
          iconUrl: iconUrl,
          name: name,
          coverImageUrl: finalImageFolder,
          marqueeUrl: finalmarqueeFolder,
          videoUrl: videoUrl);
      await databaseFunctions.insertMedia(mediaInsert);
      List<String> tag = List.empty(growable: true);
      tag.add("prueba");
      tag.add("adios");
      var gameInsert = Game(
          title: name,
          playTime: playtime,
          platform: Platforms.Windows.name,
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

  /* ----------------------------- Get SteamGridDB Heroes (Marquees) by Steam App Id and Platform ---------------------------- */
  Future<String> getAndImportSteamGridDBHeroesBySteamIdAndPlatform(
      {required String key,
      required String steamId,
      required String platform}) async {
    // Definir los encabezados que deseas enviar
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $key',
      'Content-Type': 'application/json',
    };
    Response userData = await _dio.get(
        _steamGridDBApiUrl + 'heroes/$platform/$steamId',
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
      String imageUrl = firstData['thumb'];

      //Returns the value of the first image obtained.
      return imageUrl;
    }
    return '';
  }

  Future<String> searchVideosAndReturnUrl(String query) async {
    var youtube = YoutubeExplode();
    var searchResult = await youtube.search(query);
    String urlVideo = "";
    for (var video in searchResult) {
      print('Title: ${video.title}');
      print('URL: ${video.url}');
      urlVideo = video.url;
      print('Channel: ${video.author}');
      print('Duration: ${video.duration}');
      print('Views: ${video.engagement.viewCount}');
      print('');
      //Para que solo devuelva el primer resultado
      break;
    }

    youtube.close();
    return urlVideo;
  }

  /* --------------- Downloads a videogame trailer from Youtube --------------- */

  /* ----------------------------- Get IGDB Media by Steam App Id and Platform ---------------------------- */
  /* ------------------------ Not working by the moment ----------------------- */
  Future<void> getAndImportIgdbMedia() async {
    // Definir los encabezados que deseas enviar
    // Client Secret: 00mkxqxbe6xfrjpqd9q5trciud4na5
    // ID Client: ozpvq0wx470vnfptk4pgrxx91vanzg
    final urlAut = 'https://id.twitch.tv/oauth2/token';
    try {
      // Datos que deseas enviar en el cuerpo de la solicitud
      final queryParameters = {
        'client_id': 'ozpvq0wx470vnfptk4pgrxx91vanzg',
        'client_secret': '00mkxqxbe6xfrjpqd9q5trciud4na5',
        'grant_type': 'client_credentials',
      };

      // Realiza la solicitud POST
      final response =
          await _dio.post(urlAut, queryParameters: queryParameters);

      // Maneja la respuesta aquí
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } catch (error) {
      // Maneja los errores aquí
      print('Error: $error');
    }
  }
}
