import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:synchronyx/utilities/Constants.dart';
import '../models/game.dart';

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
          'CREATE TABLE IF NOT EXISTS games(' // Agregamos "IF NOT EXISTS" para evitar errores si la tabla ya existe
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'description TEXT' // Agregamos la columna "description"
          // Resto de las columnas de la tabla ...
          ')',
        );
        //print('Tabla "games" creada correctamente.');
      },
      version: 1,
    );

    return Constants.database;
  } catch (e) {
    print('Error al abrir la base de datos: $e');
    rethrow;
  }
}

///
///
///Inserts a game in database
Future<void> insertGame(Game game) async {
  //var database = await createAndOpenDB();
  await Constants.database?.insert(
    'games',
    game.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // Ahora puedes cerrar la base de datos después de la inserción
  await Constants.database?.close();
}
