import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/api.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:synchronyx/widgets/arcade_box_button.dart';
import '../models/game.dart';

/* -------------------------------------------------------------------------- */
/*                             DATABASE FUNCTIONS                             */
/* -------------------------------------------------------------------------- */

Future<Database?> openExistingDatabase() async {
  if (Constants.database != null) {
    return Constants.database;
  }
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'synchronyx.db');
  var exists = await databaseExists(path);

  // Abrir la base de datos si aún no está abierta
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

  if (!exists) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    var data = await rootBundle.load(join('assets/database/', 'synchronyx.db'));
    List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await File(path).writeAsBytes(bytes, flush: true);
  }

  try {
    Constants.database = await openDatabase(
      path,
      onConfigure: (db) {
        // Aquí puedes realizar cualquier configuración adicional de la base de datos antes de que se abra
      },
      onCreate: (db, version) async {
        // Aquí puedes crear las tablas utilizando la función db.execute
        // Por ejemplo, para crear la tabla de juegos, puedes hacer lo siguiente:
        await db.execute(
          'CREATE TABLE IF NOT EXISTS games('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'title TEXT,'
          'description TEXT,'
          'boxColor TEXT,'
          'coverImage TEXT,'
          'backImage TEXT,'
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
        // Crear la tabla de apis
        await db.execute(
          'CREATE TABLE IF NOT EXISTS apis('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'name TEXT,'
          'url TEXT,'
          'apiKey TEXT,'
          'steamId TEXT'
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

  // Query the table for all The Games.
  final List<Map<String, dynamic>> maps = await db!.query('games');

  // Convert the List<Map<String, dynamic> into a List<Game>.
  return List.generate(maps.length, (i) {
    return Game(
      id: maps[i]['id'],
      title: maps[i]['title'],
      description: maps[i]['description'],
      lastPlayed: maps[i]['lastPlayed'],
    );
  });
}

Future<Api?> checkApiByName(String name) async {
  //print('Base de datos abierta en:${Constants.database}');
  // Verifica si la base de datos está abierta antes de continuar
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

/* ----- A method to check if some Api with "steam" name exists ----- */
Future<bool> checkIfSteamApiDataExist() async {
  // Get a reference to the database.
  final db = await Constants.database;

  // Perform the query in the database.
  final List<Map<String, dynamic>> maps = await db!.query(
    'apis',
    where: 'name = ?',
    whereArgs: ['steam', 'Steam'],
  );

  // Close the database after use.
  //await db.close();

  // Check if any api with the name "steam" was found.".
  return maps.isNotEmpty;
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

  await Constants.database?.close();
}

/* ---------------------- ///Inserts a game in database --------------------- */
Future<void> insertGame(Game game) async {
  //var database = await createAndOpenDB();
  await Constants.database?.insert(
    'games',
    game.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  await Constants.database?.close();
}

/* -------------------------------------------------------------------------- */
/*                              UPDATE FUNCTIONS                              */
/* -------------------------------------------------------------------------- */

/* ---------------------- ///Update a game in database ---------------------- */
Future<void> updateGame(Game game) async {
  await Constants.database
      ?.update('games', game.toMap(), where: 'id = ?', whereArgs: [game.id]);

  // Ahora puedes cerrar la base de datos después de la actualizacion
  await Constants.database?.close();
}
