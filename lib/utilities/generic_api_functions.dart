import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronyx/models/media.dart';
import 'package:synchronyx/models/responses/khinsider_response.dart';
import 'package:synchronyx/models/responses/rawg_response.dart';
import '../models/game.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    // ignore: library_prefixes
    as databaseFunctions;
import 'Constants.dart';
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

  final _rawgApiUrl = 'https://api.rawg.io/api/games';

  var IgdbAccessToken;

/* ----------------------------- Get Steam Games ---------------------------- */
  Future<void> getAndImportSteamGames(
      {required String key, required String steamId}) async {
    int requestCount = 0; //Number of request per progress bar counting
    Response userData = await _dio.get(
        _steamApiUrl + '$key&steamid=$steamId&format=json&include_appinfo=1');
    String jsonData = jsonEncode(userData.data);
    //print('User Info Data: $jsonData');

    Map<String, dynamic> responseData = userData.data;
    List<dynamic> gamesList = responseData['response']['games'];

    for (var game in gamesList) {
      requestCount++;
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
      Media? mediaInfo;
      String finalImageFolder =
          await processMediaFiles(imageFrontUrl, "cover", name, mediaInfo);

      //We import by default from SteamGridDB, marquee image
      String marqueeFrontUrl =
          await getAndImportSteamGridDBHeroesBySteamIdAndPlatform(
              key: 'fa61b6d47dfe3b6ab65a516b1f8bd0a3',
              steamId: '$appId',
              platform: 'steam');
      String finalmarqueeFolder =
          await processMediaFiles(marqueeFrontUrl, "marquee", name, mediaInfo);

      //We import by default from SteamGridDB, marquee image
      String logoUrl = await getAndImportSteamGridDBLogoBySteamIdAndPlatform(
          key: 'fa61b6d47dfe3b6ab65a516b1f8bd0a3',
          steamId: '$appId',
          platform: 'steam');
      String finallogoFolder =
          await processMediaFiles(logoUrl, "logo", name, mediaInfo);

      //Get info from RAWG
      RawgResponse rawgResponse = await getAndImportRawgData(
          key: '68239c29cb2c49f2acfddf9703077032', title: name);
      String finalbackgroundFolder = await processMediaFiles(
          rawgResponse.imageUrl, "background", name, mediaInfo);

      //Get video for Media insert
      String videoUrl = await searchVideosAndReturnUrl('$name trailer');
      //Primero inserto el juego
      List<String> tag = List.empty(growable: true);
      tag.add("prueba");
      tag.add("adios");
      Game gameInsert = Game(
          title: name,
          installed: 1,
          favorite: 0,
          playTime: playtime,
          releaseDate: DateTime.parse(rawgResponse.releaseDate!),
          rating: rawgResponse.metacriticInfo,
          developer: rawgResponse.developer!,
          publisher: rawgResponse.publisher!,
          platform: GamePlatforms.Windows.name,
          platformStore: PlatformStore.Steam.name,
          tags: tag.join(','));
      await databaseFunctions.insertGame(gameInsert);

      //Luego inserto los medios
      var mediaInsert = Media(
          iconUrl: iconUrl,
          name: name,
          screenshots: rawgResponse.screenshots!,
          logoUrl: finallogoFolder,
          coverImageUrl: finalImageFolder,
          marqueeUrl: finalmarqueeFolder,
          backgroundImageUrl: finalbackgroundFolder,
          videoUrl: videoUrl);
      await databaseFunctions.insertMedia(mediaInsert, gameInsert);

      updateProgress(requestCount, gamesList.length);
      if (requestCount > 1) break;
    }
  }

  Future<String> processMediaFiles(
      String img, String mediaType, String name, Media? mediaInfo) async {
    List<String> parts = img.split('/');
    String lastPartFile = parts.last;
    String imageName = '${generateRandomAlphanumeric()}_$lastPartFile';
    String imageFolder = "";
    mediaInfo = await databaseFunctions.getMediaByName(name);
    //print(mediaInfo?.name);
    switch (mediaType) {
      case "cover":
        imageFolder = '\\Synchronyx\\media\\frontCovers\\';
        //Delete file before download a new one
        if (mediaInfo != null) {
          deleteFile(mediaInfo!.coverImageUrl);
        }
        break;
      case "marquee":
        imageFolder = '\\Synchronyx\\media\\marquees\\';
        //Delete file before download a new one
        if (mediaInfo != null) {
          deleteFile(mediaInfo!.marqueeUrl);
        }
        break;
      case "background":
        imageFolder = '\\Synchronyx\\media\\backgrounds\\';
        //Delete file before download a new one
        if (mediaInfo != null) {
          deleteFile(mediaInfo!.backgroundImageUrl);
        }
        break;
      case "logo":
        imageFolder = '\\Synchronyx\\media\\logos\\';
        //Delete file before download a new one
        if (mediaInfo != null) {
          deleteFile(mediaInfo!.logoUrl);
        }
        break;
    }
    downloadAndSaveImage(img, imageName, imageFolder);
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String finalImageFolder =
        '${appDocumentsDirectory.path}$imageFolder$imageName';
    return finalImageFolder;
  }

  /* -------------------------------------------------------------------------- */
  /*                             Scrappers for Media                            */
  /* -------------------------------------------------------------------------- */

/* ------------------------ Get music from Khinsider ------------------------ */
  Future<List<KhinsiderResponse>> scrapeKhinsider(
      {required String title}) async {
    String searchTitle = createSearchString(title);
    List<KhinsiderResponse> results = [];
    final url = 'https://downloads.khinsider.com/search?search=$searchTitle';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);

      final table = document.querySelector('.albumList');
      if (table != null) {
        final rows = table.querySelectorAll('tr');

        for (var i = 1; i < rows.length; i++) {
          // Start from the second element
          final row = rows[i];
          KhinsiderResponse kResponse = new KhinsiderResponse(nameAlbum: '');
          final title = row.querySelectorAll(
              'td')[1]; // Select the second <td> in the row - Title
          final platform = row.querySelectorAll(
              'td')[2]; // Select the third <td> in the row - platform
          final year = row.querySelectorAll(
              'td')[4]; // Select the forth <td> in the row - year
          if (title != null) {
            kResponse = KhinsiderResponse(
                nameAlbum: title.text,
                platform: platform.text,
                year: int.parse(year.text));
          }
          final urlElement =
              'https://downloads.khinsider.com${title.querySelector('a')!.attributes['href']}';
          final responseSongs = await http.get(Uri.parse(urlElement));
          if (responseSongs.statusCode == 200) {
            final document = parser.parse(responseSongs.body);
            final table = document.querySelector('table[id="songlist"]');
            //Cuento las columnas que tiene cada columna
            if (table != null) {
              final rows = table.querySelectorAll('tr');
              //print(rows.length-2);
              for (var i = 1; i < rows.length - 1; i++) {
                // Start from the second element
                final row = rows[i];
                int songNumber = 0; //Song number
                String title = ''; //Song title
                String length = ''; //Song length
                String size = ''; //Song size
                String urlMp3 = ''; //Song url page
                RegExp regex =
                    RegExp(r'^\d+\.'); //Coincide un numero y un punto
                if (regex.hasMatch(row.querySelectorAll('td')[2].text)) {
                  songNumber = int.parse(
                      row.querySelectorAll('td')[2].text.replaceAll('.', ''));
                  title = row.querySelectorAll('td')[3].text;
                  length = row.querySelectorAll('td')[4].text;
                  size = row.querySelectorAll('td')[5].text;
                  urlMp3 = row
                      .querySelectorAll('td')[5]
                      .querySelector('a')!
                      .attributes['href']!;
                }
                if (regex.hasMatch(row.querySelectorAll('td')[1].text)) {
                  songNumber = int.parse(
                      row.querySelectorAll('td')[1].text.replaceAll('.', ''));
                  title = row.querySelectorAll('td')[2].text;
                  length = row.querySelectorAll('td')[3].text;
                  size = row.querySelectorAll('td')[4].text;
                  urlMp3 = row
                      .querySelectorAll('td')[4]
                      .querySelector('a')!
                      .attributes['href']!;
                }
                KhinsiderTrackResponse k = KhinsiderTrackResponse(
                    songNumber: songNumber,
                    title: title,
                    length: length,
                    size: size,
                    url: urlMp3);
                kResponse.tracks.add(k);
              }
            }
          }
          //print(kResponse.nameAlbum);
          results.add(kResponse);
        }
      }
    } else {
      print('Error: ${response.statusCode}');
    }
    return results;
  }

  //Get the mp3 url to download or play
  Future<String> getMp3UrlDownload({required String url}) async {
    String playerUrl = ''; //Song url to download
    final responseSongsUrl =
        await http.get(Uri.parse('https://downloads.khinsider.com$url'));
    if (responseSongsUrl.statusCode == 200) {
      final documentSong = parser.parse(responseSongsUrl.body);
      playerUrl =
          documentSong.querySelector('audio[id="audio"]')!.attributes['src'] ??
              "";
    }
    return playerUrl;
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

  /* ----------------------------- Get SteamGridDB Logo by Steam App Id and Platform ---------------------------- */
  Future<String> getAndImportSteamGridDBLogoBySteamIdAndPlatform(
      {required String key,
      required String steamId,
      required String platform}) async {
    // Definir los encabezados que deseas enviar
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $key',
      'Content-Type': 'application/json',
    };
    Response userData = await _dio.get(
        _steamGridDBApiUrl + 'logos/$platform/$steamId',
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

  /* ----------------------------- Get RAWG Media by Steam App Id and Platform ---------------------------- */
  /* ------------------------ Not working by the moment ----------------------- */
  Future<RawgResponse> getAndImportRawgData(
      {required String key, required String title}) async {
    String sluggedTitle = createSlug(title);
    Response userData = await _dio.get('$_rawgApiUrl/$sluggedTitle?key=$key');

    Map<String, dynamic> responseData = userData.data;

    String id =
        responseData.containsKey('id') ? responseData['id'].toString() : '';

    // Get "background_image" field if it exists
    String imageUrl = responseData.containsKey('background_image')
        ? responseData['background_image']
        : '';
    //Get developer if exists
    String developersNames = '';
    List<String> developers = List.empty(growable: true);
    if (responseData.containsKey('developers') &&
        responseData['developers'] is List) {
      List<dynamic> developersList = responseData['developers'];
      for (var developerData in developersList) {
        if (developerData.containsKey('name')) {
          developers.add(developerData['name']);
        }
      }
      developersNames = developers.join(', ');
    }

    //Get publisher if exists
    String publisherNames = '';
    List<String> publishers = List.empty(growable: true);
    if (responseData.containsKey('publishers') &&
        responseData['publishers'] is List) {
      List<dynamic> publisherList = responseData['publishers'];
      for (var publisherData in publisherList) {
        if (publisherData.containsKey('name')) {
          publishers.add(publisherData['name']);
        }
      }
      publisherNames = publishers.join(', ');
    }

    String releaseDate =
        responseData.containsKey('released') ? responseData['released'] : null;

    // Get the desired field from the Metacritic response
    dynamic metacriticInfo =
        responseData.containsKey('rating') ? responseData['rating'] : null;

    //I get the screenshots of the game
    Response screensData =
        await _dio.get('$_rawgApiUrl/$id/screenshots?key=$key');

    Map<String, dynamic> responseScreensData = screensData.data;

    String screenNames = '';
    List<String> sc = List.empty(growable: true);
    if (responseScreensData.containsKey('results') &&
        responseScreensData['results'] is List) {
      List<dynamic> scList = responseScreensData['results'];
      for (var scData in scList) {
        if (scData.containsKey('image')) {
          //sc.add(scData['image']);
          //}
          List<String> parts = scData['image'].split('/');
          String lastPartFile = parts.last;
          String imageName = '${id}_$lastPartFile';
          String imageFolder = '\\Synchronyx\\media\\screenshots\\$id\\';
          processScreenshots(scData['image'], imageName, imageFolder);
          sc.add(imageName);
        }
      }

      screenNames = sc.join(',');
    }

    // Crear una instancia de MediaInfo con los datos recopilados
    RawgResponse mediaInfo = RawgResponse(
        gameId: id,
        imageUrl: imageUrl,
        metacriticInfo: metacriticInfo as double,
        releaseDate: releaseDate,
        screenshots: screenNames,
        developer: developersNames,
        publisher: publisherNames);

    return mediaInfo;
  }

/* --------------- Downloads a videogame trailer from Youtube --------------- */
  Future<String> searchVideosAndReturnUrl(String query) async {
    var youtube = YoutubeExplode();
    var searchResult = await youtube.search(query);
    String urlVideo = "";
    /*for (var video in searchResult) {
      print('Title: ${video.title}');
      print('URL: ${video.url}');
      urlVideo = video.url;
      print('Channel: ${video.author}');
      print('Duration: ${video.duration}');
      print('Views: ${video.engagement.viewCount}');
      print('');
      //Para que solo devuelva el primer resultado
      break;
    }*/

    youtube.close();
    return urlVideo;
  }

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
