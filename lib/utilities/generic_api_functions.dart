import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:synchronyx/utilities/constants.dart';
import '../models/game.dart';

/* -------------------------------------------------------------------------- */
/*                                API Functions                               */
/* -------------------------------------------------------------------------- */
class DioClient {
  final Dio _dio = Dio();

  final _steamApiUrl = 'https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=';


/* ----------------------------- Get Steam Games ---------------------------- */
  Future<void> getGames({required String key,required String steamId}) async {
    // Perform GET request to the endpoint "/users/<id>"
    Response userData = await _dio.get(_steamApiUrl + '$key&steamid=$steamId&format=json');

    // Prints the raw data returned by the server
    print('User Info: ${userData.data}');

    // Parsing the raw JSON data to the User class
    //User user = User.fromJson(userData.data);

    //return user;
}
}
