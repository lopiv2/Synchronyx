import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:synchronyx/models/media.dart';
import '../models/api.dart';
import 'package:synchronyx/utilities/constants.dart';
import '../models/game.dart';

/* -------------------------------------------------------------------------- */
/*                             DATABASE FUNCTIONS                             */
/* -------------------------------------------------------------------------- */

Future<Database?> openExistingDatabase() async {
  if (Constants.database != null) {
    print("existe");
    return Constants.database;
  }
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'synchronyx.db');
  var exists = await databaseExists(path);

  // Open database if not already open
  Constants.database = await openDatabase(path);

  return Constants.database;
}

Future<Database?> createAndOpenDB() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  var databasesPath = await getDatabasesPath();
  //Ruta: Synchronyx\synchronyx\.dart_tool\sqflite_common_ffi\databases
  String path = join(databasesPath, 'synchronyx.db');
  var exists = await databaseExists(path);

  try {
    if (!exists) {
      await Directory(dirname(path)).create(recursive: true);

      var data =
          await rootBundle.load(join('assets/database/', 'synchronyx.db'));
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(path).writeAsBytes(bytes, flush: true);
    }

    Constants.database = await openDatabase(
      path,
      onConfigure: (db) {
        // Here you can perform any additional database configuration before it is opened.
      },
      onCreate: (db, version) async {
        // Create the games table
        await db.execute(
          'CREATE TABLE IF NOT EXISTS games('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'title TEXT,'
          'description TEXT,'
          'boxColor TEXT,'
          'mediaId INTEGER,'
          'platform TEXT,'
          'genres TEXT,'
          'maxPlayers INTEGER,'
          'developer TEXT,'
          'publisher TEXT,'
          'region TEXT,'
          'file TEXT,'
          'releaseYear INTEGER,'
          'rating REAL,'
          'favorite INTEGER,'
          'playTime INTEGER,'
          'lastPlayed TEXT,'
          'tags TEXT'
          ')',
        );
        // Create the apis table
        await db.execute(
          'CREATE TABLE IF NOT EXISTS apis('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'name TEXT,'
          'url TEXT,'
          'metadataJson TEXT'
          ')',
        );
        // Create the Medias table
        await db.execute(
          'CREATE TABLE IF NOT EXISTS medias('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'name TEXT,'
          'coverImageUrl TEXT,'
          'backImageUrl TEXT,'
          'diskImageUrl TEXT,'
          'videoUrl TEXT,'
          'marqueeUrl TEXT,'
          'screenshots TEXT,'
          'iconUrl TEXT,'
          'logoUrl TEXT'
          ')',
        );
      },
      version: 1,
    );
    return Constants.database;
  } catch (e) {
    print('Error al abrir la base de datos: $e');
    rethrow;
  }
}

/* -------------------------------------------------------------------------- */
/*                                GET FUNCTIONS                               */
/* -------------------------------------------------------------------------- */

/* ------- A method that retrieves all the games from the games table. ------ */
Future<List<Game>> getAllGames() async {
  // Get a reference to the database.
  final db = await Constants.database;

  List<Map<String, dynamic>> maps = List.empty(growable: true);

  if (db != null) {
    // Query the table for all The Games.
    maps = await db!.query('games');
  }

  // Convert the List<Map<String, dynamic> into a List<Game>.
  return List.generate(maps.length, (i) {
    return Game(
      id: maps[i]['id'],
      title: maps[i]['title'],
      mediaId: maps[i]['mediaId'],
      description: maps[i]['description'],
      //lastPlayed: maps[i]['lastPlayed'],
    );
  });
}

/* ---------------------------- Check Api by name --------------------------- */
Future<Api?> checkApiByName(String name) async {
  //print('Base de datos abierta en:${Constants.database}');
  // Verify if the database is open before continuing
  if (Constants.database != null) {
    var apis = await Constants.database
        ?.query('apis', where: 'name = ?', whereArgs: [name]);
    if (apis!.isNotEmpty) {
      // Return the first API found (assuming 'name' is unique in the database)
      //print(apis.first);
      return Api.fromMap(apis.first);
    } else {
      return null; // Return null if no matching API is found
    }
  }
}

/* ----------- Gets game from database with title parameter ---------- */
Future<Game?> getGameByTitle(String name) async {
  //print('Base de datos abierta en:${Constants.database}');
  // Verify if the database is open before continuing
  if (Constants.database != null) {
    var game = await Constants.database
        ?.query('games', where: 'title = ?', whereArgs: [name]);
    if (game!.isNotEmpty) {
      // Return the first API found (assuming 'name' is unique in the database)
      //print(apis.first);
      return Game.fromMap(game.first);
    } else {
      return null; // Return null if no matching API is found
    }
  }
}

/* ----------- Gets media record from database with name parameter ---------- */
Future<Media?> getMediaByName(String name) async {
  //print('Base de datos abierta en:${Constants.database}');
  // Verify if the database is open before continuing
  if (Constants.database != null) {
    var media = await Constants.database
        ?.query('medias', where: 'name = ?', whereArgs: [name]);
    if (media!.isNotEmpty) {
      // Return the first API found (assuming 'name' is unique in the database)
      //print(apis.first);
      return Media.fromMap(media.first);
    } else {
      return null; // Return null if no matching API is found
    }
  }
}

/* ----------- Gets media record from database with id parameter ---------- */
Future<Media?> getMediaById(int id) async {
  // Verify if the database is open before continuing
  if (Constants.database != null) {
    var media = await Constants.database
        ?.query('medias', where: 'id = ?', whereArgs: [id]);
    if (media!.isNotEmpty) {
      return Media.fromMap(media.first);
    } else {
      return null; // Return null if no matching API is found
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                              DELETE FUNCTIONS                              */
/* -------------------------------------------------------------------------- */

/* ------------------- ///Deletes a game from the database ------------------ */
Future<void> deleteGame(int id) async {
  // Get a reference to the database.
  final db = await Constants.database;

  // Remove the Game from the database.
  await db!.delete(
    'games',
    // Use a `where` clause to delete a specific game.
    where: 'id = ?',
    // Pass the Game's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

/* -------------------------------------------------------------------------- */
/*                              INSERT FUNCTIONS                              */
/* -------------------------------------------------------------------------- */

/* ---------------------- ///Inserts an API in database --------------------- */
Future<void> insertApi(Api api) async {
  //var database = await createAndOpenDB();
  await Constants.database?.insert(
    'apis',
    api.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  //await Constants.database?.close();
}

/* ---------------------- Inserts a game in database --------------------- */
Future<void> insertGame(Game game) async {
  await Constants.database?.insert(
    'games',
    game.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

/* ------------------------ Inserts media in database ----------------------- */
Future<void> insertMedia(Media media) async {
  //var database = await createAndOpenDB();
  await Constants.database?.insert(
    'medias',
    media.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  //await Constants.database?.close();
}

/* -------------------------------------------------------------------------- */
/*                              UPDATE FUNCTIONS                              */
/* -------------------------------------------------------------------------- */

/* ---------------------- ///Update a game in database by ID ---------------- */
Future<void> updateGameById(Game game) async {
  await Constants.database
      ?.update('games', game.toMap(), where: 'id = ?', whereArgs: [game.id]);

  // Now you can close the database after the update.
  //await Constants.database?.close();
}

/* ---------------------- ///Update a game in database by ID ---------------- */
Future<void> updateGameByName(Game game) async {
  await Constants.database?.update('games', game.toMap(),
      where: 'title = ?', whereArgs: [game.title]);

  // Now you can close the database after the update.
  //await Constants.database?.close();
}
