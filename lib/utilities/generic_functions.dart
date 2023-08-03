import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import '../models/game.dart';

Future<Database> getDB() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'synchronyx.db');
  var exists = await databaseExists(path);

  if (!exists) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    var data = await rootBundle.load(join('assets/database', 'synchronyx.db'));
    List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await File(path).writeAsBytes(bytes, flush: true);
  }

  return await openDatabase(
    path,
    onCreate: (db, version) {
      // Aquí puedes crear las tablas utilizando la función db.execute
      // Por ejemplo, para crear la tabla de juegos, puedes hacer lo siguiente:
      db.execute(
        'CREATE TABLE games('
        'id INTEGER PRIMARY KEY,'
        'title TEXT,'
        'description TEXT,'
        'coverImage TEXT'
        // Resto de las columnas de la tabla ...
        ')',
      );
    },
    version:
        1, // Puedes cambiar la versión de la base de datos aquí si es necesario
  );
}

Future<void> insertGame(Game game) async {
  var database = await getDB();
  await database.insert(
    'games',
    game.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
