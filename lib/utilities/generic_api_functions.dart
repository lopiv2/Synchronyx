import 'dart:async';
import 'dart:convert';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:synchronyx/icons/custom_icons_icons.dart';
import 'package:synchronyx/models/cheapSharkStores.dart';
import 'package:synchronyx/models/media.dart';
import 'package:synchronyx/models/responses/cheapSharkResponse_response.dart';
import 'package:synchronyx/models/responses/emulator_download_response.dart';
import 'package:synchronyx/models/responses/khinsider_response.dart';
import 'package:synchronyx/models/responses/rawg_response.dart';
import 'package:synchronyx/models/responses/steamgriddb_response.dart';
import '../models/game.dart';
import 'package:html/parser.dart' as parser;
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

  DioClient() {
    final cacheOptions = CacheOptions(
      store: FileCacheStore(
        './documents_cache', // Cambia a la ubicación deseada
      ),
      policy: CachePolicy.forceCache, // Cambia esto según tus necesidades
      hitCacheOnErrorExcept: [500, 401, 403], // Cambia según tus necesidades
      priority: CachePriority.normal, // Prioridad de la caché
      maxStale: const Duration(days: 1), //Cache duration of 1 day
    );

    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  final _steamApiUrl =
      'https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=';

  final _giantBombApiUrl = 'http://www.giantbomb.com/api/search/?api_key=';

  final _steamGridDBApiUrl = 'https://www.steamgriddb.com/api/v2/';

  final _rawgApiUrl = 'https://api.rawg.io/api/games';

  var IgdbAccessToken;

  /* --------- Adds a searched game from list to Database to shop list -------- */
  Future<void> addBuyableGameToList(RawgResponse game) async {
    //Buscar todo esto en Steamgrid a partir del nombre, obtengo el id del juego
    String key = '68239c29cb2c49f2acfddf9703077032';
    List<String> tag = List.empty(growable: true);
    tag.add("prueba");
    tag.add("adios");
    Game gameInsert = Game(
        title: game.name ?? '',
        installed: 0,
        favorite: 0,
        description: game.description ?? '',
        playTime: 0,
        releaseDate: DateTime.parse(game.releaseDate!),
        rating: game.metacriticInfo,
        developer: game.developer!,
        publisher: game.publisher!,
        platform: game.platform ?? '',
        platformStore: game.store ?? '',
        owned: 0,
        tags: tag.join(','));
    await databaseFunctions.insertGame(gameInsert);
    Response screensData =
        await _dio.get('$_rawgApiUrl/${game.gameId}/screenshots?key=$key');
    await Constants.initialize();
    Map<String, dynamic> responseScreensData = screensData.data;
    Media? mediaInfo;
    String screenNames = '';
    List<String> sc = List.empty(growable: true);
    if (responseScreensData.containsKey('results') &&
        responseScreensData['results'] is List) {
      List<dynamic> scList = responseScreensData['results'];
      for (var scData in scList) {
        if (scData.containsKey('image')) {
          List<String> parts = scData['image'].split('/');
          String lastPartFile = parts.last;
          String imageName = '${game.gameId}_$lastPartFile';
          String imageFolder =
              '\\Synchronyx\\media\\screenshots\\${game.gameId}\\';
          processScreenshots(scData['image'], imageName, imageFolder);
          sc.add(imageName);
        }
      }
    }
    screenNames = sc.join(',');
    SteamgridDBResponse st = await getAndImportSteamGridDBMediaByGame(
        key: 'fa61b6d47dfe3b6ab65a516b1f8bd0a3', searchString: game.name ?? '');
    String finalLogoFolder = await processMediaFiles(
        st.logoUrl ?? '', "logo", game.name ?? '', mediaInfo);
    String finalIconFolder = await processMediaFiles(
        st.iconUrl ?? '', "icon", game.name ?? '', mediaInfo);
    String finalCoverFolder = await processMediaFiles(
        st.coverUrl ?? '', "cover", game.name ?? '', mediaInfo);
    String finalMarqueeFolder = await processMediaFiles(
        st.marqueeUrl ?? '', "marquee", game.name ?? '', mediaInfo);
    String finalBackgroundFolder = await processMediaFiles(
        game.imageUrl ?? '', "background", game.name ?? '', mediaInfo);
    //Then I insert the media
    var mediaInsert = Media(
        iconUrl: finalIconFolder,
        name: game.name ?? '',
        screenshots: screenNames,
        logoUrl: finalLogoFolder,
        coverImageUrl: finalCoverFolder,
        marqueeUrl: finalMarqueeFolder,
        backgroundImageUrl: finalBackgroundFolder,
        videoUrl: '');
    await databaseFunctions.insertMedia(mediaInsert, gameInsert);
  }

/* ----------------------------- Get Steam Games ---------------------------- */
  Future<void> getAndImportSteamGames(
      {required String key, required String steamId}) async {
    int requestCount = 0; //Number of request per progress bar counting
    await Constants.initialize();
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
      String finalLogoFolder =
          await processMediaFiles(logoUrl, "logo", name, mediaInfo);

      //Get info from RAWG
      RawgResponse rawgResponse = await getAndImportRawgData(
          key: '68239c29cb2c49f2acfddf9703077032', title: name);
      String finalbackgroundFolder = await processMediaFiles(
          rawgResponse.imageUrl ?? '', "background", name, mediaInfo);

      //Get video for Media insert
      String videoUrl = await searchVideosAndReturnUrl('$name trailer');
      //First I insert the game
      List<String> tag = List.empty(growable: true);
      tag.add("prueba");
      tag.add("adios");
      Game gameInsert = Game(
          title: name,
          installed: 1,
          favorite: 0,
          description: rawgResponse.description ?? '',
          playTime: playtime,
          releaseDate: DateTime.parse(rawgResponse.releaseDate!),
          rating: rawgResponse.metacriticInfo,
          developer: rawgResponse.developer!,
          publisher: rawgResponse.publisher!,
          platform: GamePlatforms.Windows.name,
          platformStore: PlatformStore.Steam.name,
          owned: 1,
          tags: tag.join(','));
      await databaseFunctions.insertGame(gameInsert);

      //Then I insert the media
      var mediaInsert = Media(
          iconUrl: iconUrl,
          name: name,
          screenshots: rawgResponse.screenshots!,
          logoUrl: finalLogoFolder,
          coverImageUrl: finalImageFolder,
          marqueeUrl: finalmarqueeFolder,
          backgroundImageUrl: finalbackgroundFolder,
          videoUrl: videoUrl);
      await databaseFunctions.insertMedia(mediaInsert, gameInsert);

      updateProgress(requestCount, gamesList.length);
      if (requestCount > 5) break;
    }
  }

/* ------------ Search for the game with the text entered in Rawg ----------- */
  Future<List<RawgResponse>> searchGamesRawg(
      {required String key, required String searchString}) async {
    try {
      final Response userData =
          await _dio.get('$_rawgApiUrl?key=$key&search=$searchString');

      if (userData.statusCode == 200 || userData.statusCode == 304) {
        final Map<String, dynamic> jsonResponse = userData.data;

        if (jsonResponse.containsKey('results')) {
          final List<dynamic> results = jsonResponse['results'];
          if (results.isNotEmpty) {
            final List<RawgResponse> games = [];

            for (final data in results) {
              if (data is Map<String, dynamic> && data.containsKey('name')) {
                final String gameName = data['name'];
                SteamgridDBResponse stResp;
                stResp = await getAndImportSteamGridDBMediaByGame(
                    key: 'fa61b6d47dfe3b6ab65a516b1f8bd0a3',
                    searchString: gameName);
                String iconUrl = stResp.iconUrl ?? '';
                String coverUrl = data['background_image'];
                try {
                  final Response gameData = await _dio
                      .get('$_rawgApiUrl/${data['id'].toString()}?key=$key');
                  Map<String, dynamic> responseData = gameData.data;

                  String description = responseData.containsKey('description')
                      ? responseData['description'].toString()
                      : '';

                  final List<dynamic> platforms = data['platforms'];
                  String platformName = '';

                  if (platforms.isNotEmpty) {
                    final platformData = platforms[0]['platform'];
                    if (platformData is Map<String, dynamic> &&
                        platformData.containsKey('name')) {
                      platformName = platformData['name'] as String;
                      if (platformName == 'PC') {
                        platformName = 'Windows';
                      }
                    }
                  } else {
                    // El array 'platforms' está vacío o no contiene elementos válidos.
                  }

                  //Stores
                  String storeName = '';
                  if (data['stores'] != null) {
                    final List<dynamic> stores = data['stores'];
                    if (stores.isNotEmpty) {
                      final storeData = stores[0]['store'];
                      if (storeData is Map<String, dynamic> &&
                          storeData.containsKey('name')) {
                        storeName = storeData['name'].toString().toLowerCase();
                      }
                    } else {
                      // El array 'stores' está vacío o no contiene elementos válidos.
                    }
                  }

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
                  final RawgResponse game = RawgResponse(
                    gameId: data['id'].toString(),
                    name: data['name'],
                    description: description,
                    imageUrl: coverUrl,
                    iconUrl: iconUrl,
                    developer: developersNames,
                    publisher: publisherNames,
                    platform: platformName,
                    store: storeName,
                    metacriticInfo: data['rating'],
                    releaseDate: data['released'],
                  );
                  games.add(game);
                } catch (e) {
                  throw Exception('HTTP request error: $e');
                }
              }
            }
            return games;
          } else {
            return []; // Return an empty list if there are no results
          }
        } else {
          throw Exception(
              'The "results" field was not found in the JSON response.');
        }
      } else {
        print(userData.statusCode);
        throw Exception('HTTP request error');
      }
    } catch (e) {
      throw Exception('HTTP request error: $e');
    }
  }

/* -------------------------- Media file processing ------------------------- */
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
          deleteFile(mediaInfo.coverImageUrl);
        }
        break;
      case "icon":
        imageFolder = '\\Synchronyx\\media\\icons\\';
        //Delete file before download a new one
        if (mediaInfo != null) {
          deleteFile(mediaInfo.iconUrl);
        }
        break;
      case "marquee":
        imageFolder = '\\Synchronyx\\media\\marquees\\';
        //Delete file before download a new one
        if (mediaInfo != null) {
          deleteFile(mediaInfo.marqueeUrl);
        }
        break;
      case "background":
        imageFolder = '\\Synchronyx\\media\\backgrounds\\';
        //Delete file before download a new one
        if (mediaInfo != null) {
          deleteFile(mediaInfo.backgroundImageUrl);
        }
        break;
      case "logo":
        imageFolder = '\\Synchronyx\\media\\logos\\';
        //Delete file before download a new one
        if (mediaInfo != null) {
          deleteFile(mediaInfo.logoUrl);
        }
        break;
    }
    downloadAndSaveImage(img, imageName, imageFolder);
    String finalImageFolder =
        '${Constants.appDocumentsDirectory.path}$imageFolder$imageName';
    return finalImageFolder;
  }

  /* -------------------------------------------------------------------------- */
  /*                             Scrappers for Media or Data                    */
  /* -------------------------------------------------------------------------- */

/* ------------------------ Get price list from CheapShark ------------------------ */
  Future<List<CheapSharkResponse>> getDealsFromCheapShark(
      {required String title}) async {
    List<CheapSharkResponse> results = [];
    String sluggedTitle = createSlug(title);
    String gameID = '';
    //Get all deal stores
    final Response storesData =
        await _dio.get('https://www.cheapshark.com/api/1.0/stores');
    final List<dynamic> storesJsonResponse = storesData.data;
    List<CheapSharkStore> stores = [];

    for (final storeData in storesJsonResponse) {
      final storeID = storeData['storeID'] as String;
      final storeName = storeData['storeName'] as String;
      final storeLogoUrl = storeData['images']['logo'] as String;

      final store = CheapSharkStore(
        storeID: storeID,
        storeName: storeName,
        storeLogoUrl: storeLogoUrl,
      );

      stores.add(store);
    }

    //Get game ID
    final Response userData =
        await _dio.get('https://www.cheapshark.com/api/1.0/games?title=$title');
    final List<dynamic> jsonResponse = userData.data;

    for (final Map<String, dynamic> gameData in jsonResponse) {
      gameID = gameData['gameID'];
      break;
    }

    final Response dealData =
        await _dio.get('https://www.cheapshark.com/api/1.0/games?id=$gameID');

    if (dealData.statusCode == 200 || dealData.statusCode == 304) {
      final Map<String, dynamic> jsonResponse = dealData.data;

      // Extraer información del juego
      final String title = jsonResponse['info']['title'];
      final String steamAppID = jsonResponse['info']['steamAppID'];
      final String thumb = jsonResponse['info']['thumb'];

      // Extraer información de las ofertas
      final List<dynamic> deals = jsonResponse['deals'];
      for (final Map<String, dynamic> deal in deals) {
        final String storeID = deal['storeID'];
        CheapSharkStore st = searchStoreById(storeID, stores);
        final String dealID = deal['dealID'];
        final double price = double.parse(deal['price']);
        final double retailPrice = double.parse(deal['retailPrice']);
        final double savings = double.parse(deal['savings']);
        CheapSharkResponse c = CheapSharkResponse(
            store: st.storeName,
            retailPrice: retailPrice,
            salePrice: price,
            logo: 'https://www.cheapshark.com${st.storeLogoUrl}',
            dealId: dealID);
        results.add(c);
      }
    } else {
      print('Error: ${dealData.statusCode}');
    }
    return results;
  }

  CheapSharkStore searchStoreById(String id, List<CheapSharkStore> stores) {
    String searchStoreID = '2'; // El ID de la tienda que deseas buscar

    CheapSharkStore? foundStore =
        stores.firstWhere((store) => store.storeID == searchStoreID);

    return foundStore;
  }

/* ------------------------ Get music from Khinsider ------------------------ */
  Future<List<KhinsiderResponse>> scrapeKhinsider(
      {required String title}) async {
    String searchTitle = createSearchString(title);
    List<KhinsiderResponse> results = [];
    final url = 'https://downloads.khinsider.com/search?search=$searchTitle';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 304) {
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
            int num = 0;
            try {
              num = int.parse(year.text);
              //print("It is a number: $num");
            } catch (e) {
              //print("It is not a parseable number.");
            }
            kResponse = KhinsiderResponse(
                nameAlbum: title.text, platform: platform.text, year: num);
          }
          final urlElement =
              'https://downloads.khinsider.com${title.querySelector('a')!.attributes['href']}';
          final responseSongs = await http.get(Uri.parse(urlElement));
          if (responseSongs.statusCode == 200 ||
              responseSongs.statusCode == 304) {
            final document = parser.parse(responseSongs.body);
            final table = document.querySelector('table[id="songlist"]');
            //Cuento las columnas que tiene cada columna
            if (table != null) {
              final rows = table.querySelectorAll('tr');
              //Looping tr
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

  /* ------------------- Get the mp3 url to download or play ------------------ */
  Future<String> getMp3UrlDownload({required String url}) async {
    String playerUrl = ''; //Song url to download
    final responseSongsUrl =
        await http.get(Uri.parse('https://downloads.khinsider.com$url'));
    if (responseSongsUrl.statusCode == 200 ||
        responseSongsUrl.statusCode == 304) {
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

  /* --------------------- Get game media from SteamGridDB --------------------- */
  Future<SteamgridDBResponse> getAndImportSteamGridDBMediaByGame(
      {required String key, required String searchString}) async {
    // Define the headers you want to send
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $key',
      'Content-Type': 'application/json',
    };
    String coverImage = '';
    String marqueeImage = '';
    String icon = '';
    String logo = '';
    Response userData = await _dio.get(
        '${_steamGridDBApiUrl}search/autocomplete/$searchString',
        options: Options(headers: headers));

    Map<String, dynamic> responseData = userData.data;
    // Obtain the "data" list
    List<dynamic> dataList = responseData['data'];

    if (dataList.isNotEmpty) {
      // Get the first item in the list
      Map<String, dynamic> firstData = dataList[0];

      String gameId = firstData['id'].toString();

      //Cover image
      Response userData2 = await _dio.get(
          '${_steamGridDBApiUrl}grids/game/$gameId',
          options: Options(headers: headers));

      Map<String, dynamic> responseData2 = userData2.data;
      List<dynamic> dataList2 = responseData2['data'];
      if (dataList2.isNotEmpty) {
        // Get the first item in the list
        Map<String, dynamic> firstData2 = dataList2[0];
        coverImage = firstData2['url'];
      }

      //ICON
      Response userData3 = await _dio.get(
          '${_steamGridDBApiUrl}icons/game/$gameId',
          options: Options(headers: headers));
      Map<String, dynamic> responseData3 = userData3.data;
      List<dynamic> dataList3 = responseData3['data'];
      if (dataList3.isNotEmpty) {
        // Obtener el primer elemento de la lista
        Map<String, dynamic> firstData3 = dataList3[0];
        icon = firstData3['thumb'];
      }

      //LOGO
      Response userData4 = await _dio.get(
          '${_steamGridDBApiUrl}logos/game/$gameId',
          options: Options(headers: headers));

      Map<String, dynamic> responseData4 = userData4.data;
      // Obtener la lista "data"
      List<dynamic> dataList4 = responseData4['data'];

      if (dataList4.isNotEmpty) {
        // Obtener el primer elemento de la lista
        Map<String, dynamic> firstData4 = dataList4[0];

        // Obtener el valor del campo "url"
        logo = firstData4['thumb'];
      }

      //Marquee Image
      Response userData5 = await _dio.get(
          '${_steamGridDBApiUrl}heroes/game/$gameId',
          options: Options(headers: headers));

      Map<String, dynamic> responseData5 = userData5.data;
      // Obtener la lista "data"
      List<dynamic> dataList5 = responseData5['data'];

      if (dataList5.isNotEmpty) {
        // Obtener el primer elemento de la lista
        Map<String, dynamic> firstData5 = dataList5[0];

        // Obtener el valor del campo "url"
        marqueeImage = firstData5['thumb'];
      }
    }
    SteamgridDBResponse st = SteamgridDBResponse(
        name: searchString,
        coverUrl: coverImage,
        marqueeUrl: marqueeImage,
        iconUrl: icon,
        logoUrl: logo);
    return st;
  }

/* --------------------- Get icon game from SteamGridDB --------------------- */
  Future<String> getAndImportSteamGridDBIconByGame(
      {required String key, required String searchString}) async {
    // Definir los encabezados que deseas enviar
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $key',
      'Content-Type': 'application/json',
    };
    Response userData = await _dio.get(
        '${_steamGridDBApiUrl}search/autocomplete/$searchString',
        options: Options(headers: headers));
    //print('Game Data: $jsonData');

    Map<String, dynamic> responseData = userData.data;
    // Obtener la lista "data"
    List<dynamic> dataList = responseData['data'];

    if (dataList.isNotEmpty) {
      // Obtener el primer elemento de la lista
      Map<String, dynamic> firstData = dataList[0];

      String gameId = firstData['id'].toString();

      Response userData2 = await _dio.get(
          '${_steamGridDBApiUrl}icons/game/$gameId',
          options: Options(headers: headers));

      Map<String, dynamic> responseData2 = userData2.data;
      List<dynamic> dataList2 = responseData2['data'];
      if (dataList2.isNotEmpty) {
        // Obtener el primer elemento de la lista
        Map<String, dynamic> firstData2 = dataList2[0];
        String gameIcon = firstData2['thumb'];

        //Returns the value of the first image obtained.
        return gameIcon;
      }
    }
    return '';
  }

  /* ----------------------------- Get RAWG Media by Steam App Id and Platform ---------------------------- */
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

    final Response gameData = await _dio.get('$_rawgApiUrl/$id?key=$key');
    Map<String, dynamic> respData = gameData.data;

    String description = respData.containsKey('description')
        ? respData['description'].toString()
        : '';

    // Crear una instancia de MediaInfo con los datos recopilados
    RawgResponse mediaInfo = RawgResponse(
        gameId: id,
        imageUrl: imageUrl,
        metacriticInfo: metacriticInfo as double,
        releaseDate: releaseDate,
        description: description,
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

      // Performs the POST request
      final response =
          await _dio.post(urlAut, queryParameters: queryParameters);

      // Manage the answer here
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } catch (error) {
      print('Error: $error');
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                             Emulator Scrappers                             */
  /* -------------------------------------------------------------------------- */

/* ------------------------- BSNES Emulator Scrapper ------------------------ */
  Future<List<EmulatorDownloadResponse>> bsnesScrapper(
      {required String url}) async {
    //String searchTitle = createSearchString(title);
    List<EmulatorDownloadResponse> results = [];
    String? l = ''; //Link
    String? p = ''; //Platform
    IconData im; //Image Icon
    EmulatorDownloadResponse? response;
    //Windows
    l = 'https://github.com/bsnes-emu/bsnes/releases/download/v115/bsnes_v115-windows.zip';
    p = GamePlatforms.Windows.name;
    im = CustomIcons.windows;
    response = EmulatorDownloadResponse(system: p, url: l, image: im);
    results.add(response);
    return results;
  }

  /* ------------------------ Dolphin Emulator Scrapper ------------------------ */
  Future<List<EmulatorDownloadResponse>> dolphinScrapper(
      {required String url}) async {
    //String searchTitle = createSearchString(title);
    List<EmulatorDownloadResponse> results = [];

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 304) {
      final document = parser.parse(response.body);
      final table = document.querySelector('table.versions-list.dev-versions');
      if (table != null) {
        final rows = table.querySelectorAll('tr');

        // Start from the second tr
        final row = rows[1];
        // Select the second <td> in the row - Download links
        final downloadLinks = row.querySelectorAll('td')[1];
        //Select all the links
        final links = downloadLinks.querySelectorAll('a');
        String? l = ''; //Link
        String? p = ''; //Platform
        IconData im; //Image Icon
        EmulatorDownloadResponse? response;
        //Windows
        l = links[0].attributes['href'];
        p = GamePlatforms.Windows.name;
        im = CustomIcons.windows;
        response = EmulatorDownloadResponse(system: p, url: l, image: im);
        results.add(response);
        //MAC
        l = links[2].attributes['href'];
        p = GamePlatforms.Mac.name;
        im = CustomIcons.apple;
        response = EmulatorDownloadResponse(system: p, url: l, image: im);
        results.add(response);
        //Android
        l = links[3].attributes['href'];
        p = GamePlatforms.Android.name;
        im = CustomIcons.android;
        response = EmulatorDownloadResponse(system: p, url: l, image: im);
        results.add(response);
      }
    }
    return results;
  }

  /* ------------------------ Redream Emulator Scrapper ------------------------ */
  Future<List<EmulatorDownloadResponse>> redreamScrapper(
      {required String url}) async {
    //String searchTitle = createSearchString(title);
    List<EmulatorDownloadResponse> results = [];

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 304) {
      final document = parser.parse(response.body);
      final releasesList = document.querySelectorAll('#releases');
      List<String> links = [];
      String? l = ''; //Link
      String? p = ''; //Platform
      IconData im; //Image Icon
      EmulatorDownloadResponse? responseDownload;
      if (releasesList != null) {
        final anchorElements = releasesList[1].querySelectorAll('a');

        for (final anchorElement in anchorElements) {
          final hrefValue = anchorElement.attributes['href'];

          links.add(hrefValue ?? '');
        }
        //Windows
        l = 'https://redream.io' + links[0];
        p = GamePlatforms.Windows.name;
        im = CustomIcons.windows;
        responseDownload =
            EmulatorDownloadResponse(system: p, url: l, image: im);
        results.add(responseDownload);
        //MAC
        l = 'https://redream.io' + links[1];
        p = GamePlatforms.Mac.name;
        im = CustomIcons.apple;
        responseDownload =
            EmulatorDownloadResponse(system: p, url: l, image: im);
        results.add(responseDownload);
        //Linux
        l = 'https://redream.io' + links[2];
        p = GamePlatforms.Linux.name;
        im = CustomIcons.linux;
        responseDownload =
            EmulatorDownloadResponse(system: p, url: l, image: im);
        results.add(responseDownload);
      }
    }
    return results;
  }

  Future<List<EmulatorDownloadResponse>> snes9xScrapper(
      {required String url}) async {
    List<EmulatorDownloadResponse> results = [];

    String? l = ''; //Link
    String? p = ''; //Platform
    IconData im; //Image Icon
    EmulatorDownloadResponse? response;
    //Windows
    l = url;
    p = GamePlatforms.Windows.name;
    im = CustomIcons.windows;
    response = EmulatorDownloadResponse(system: p, url: l, image: im);
    results.add(response);

    return results;
  }
}
