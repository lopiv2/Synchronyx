import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:synchronyx/models/emulators.dart';
import 'package:synchronyx/models/responses/emulator_download_response.dart';
import 'package:synchronyx/utilities/generic_api_functions.dart';
import 'Constants.dart';

/* ------------------------- Delete a file per name ------------------------- */
Future<void> deleteFile(String fileName) async {
  try {
    final file = File(fileName);
    if (await file.exists()) {
      await file.delete();
      //print('Archivo $fileName eliminado correctamente.');
    } else {
      print('El archivo $fileName no existe.');
    }
  } catch (e) {
    print('Error al eliminar el archivo: $e');
  }
}

//Transforms a 5:30 format for example in seconds
int stringToSeconds(String value) {
  // Divide la cadena en minutos y segundos
  List<String> parts = value.split(':');

  if (parts.length == 2) {
    // Convierte las partes en enteros
    int minutes = int.tryParse(parts[0]) ?? 0;
    int seconds = int.tryParse(parts[1]) ?? 0;

    // Calcula el tiempo total en segundos
    int totalTime = (minutes * 60) + seconds;
    return totalTime;
  } else {
    // Si la cadena no tiene el formato esperado, devuelve 0 o un valor predeterminado
    return 0;
  }
}

/* ------------------------ Delete a whole directory ------------------------ */
void deleteDirectory(String folderPath) {
  Directory directory = Directory(folderPath);

  if (directory.existsSync()) {
    try {
      directory.deleteSync(recursive: true);
      print('Directorio eliminado: $folderPath');
    } catch (e) {
      print('Error al eliminar el directorio: $e');
    }
  } else {
    print('El directorio no existe: $folderPath');
  }
}

/* -------- Delete all files with different names, passed from a List ------- */
void deleteFilesFromFolder(String folderPath, List<String> files) {
  Directory directory = Directory(folderPath);
  for (String fileName in files) {
    File file = File('${directory.path}/$fileName');
    if (file.existsSync()) {
      try {
        file.deleteSync();
        print('Archivo eliminado: $fileName');
      } catch (e) {
        print('Error al eliminar $fileName: $e');
      }
    } else {
      print('El archivo $fileName no existe en la carpeta.');
    }
  }
}

/* -------------- Converts minutes to hours, minutes and seconds ------------- */
String formatMinutesToHMS(int totalMinutes) {
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;
  int seconds = 0; // Inicialmente establecido en cero segundos

  return '${hours.toString()}h  ${minutes.toString()}m  ${seconds.toString()}s';
}

/* ------------ Converts a database date to local readable format ----------- */
String formatDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('d MMMM y', 'es').format(dateTime);
  return formattedDate;
}

/* --------------------------- Convert int to bool -------------------------- */
bool convertIntBool(int? value) {
  if (value == 0) return false;
  return true;
}

int convertBoolInt(bool? value) {
  if (value == true) return 1;
  return 0;
}

/* ----------------------- Check if asset loads or not ---------------------- */
Future<void> checkAssetLoading(String assetPath) async {
  //const assetPath = 'assets/image.png'; // Reemplaza con la ruta de tu asset

  try {
    // Intenta cargar el asset utilizando el método rootBundle.load
    final ByteData data = await rootBundle.load(assetPath);
    if (data.buffer.asUint8List().isEmpty) {
      print('El asset no se cargó correctamente.');
    } else {
      print('El asset se cargó correctamente.');
    }
  } catch (error) {
    print('Error al cargar el asset: $error');
  }
}

Future<void> processScreenshots(
    String imageUrl, String fileName, String folder) async {
  try {
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      Directory imageFolder =
          Directory('${Constants.appDocumentsDirectory.path}$folder');

      // Create the directory if it doesn't exist
      if (!imageFolder.existsSync()) {
        imageFolder.createSync(recursive: true);
      }

      final file = File('${imageFolder.path}$fileName');
      await file.writeAsBytes(response.bodyBytes);
      //print('Imagen guardada en: ${file.path}');
    } else {
      print('Error al descargar la imagen: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> downloadFile(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String folder = '\\Synchronyx\\downloads\\';
      List<String> parts = url.split("/");
      String fileName = parts.last;
      await Constants.initialize();
      Directory fileFolder =
          Directory('${Constants.appDocumentsDirectory.path}$folder');

      // Create the directory if it doesn't exist
      if (!fileFolder.existsSync()) {
        fileFolder.createSync(recursive: true);
      }

      final file = File('${fileFolder.path}$fileName');
      await file.writeAsBytes(response.bodyBytes);
    } else {
      print('Error downloading file: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

/* ----------------- Formats the size in bytes and prints it ---------------- */
String formatFileSize(int sizeInBytes) {
  final kbSize = sizeInBytes / 1024;
  final mbSize = kbSize / 1024;
  final gbSize = mbSize / 1024;

  if (gbSize >= 1) {
    return '${gbSize.toStringAsFixed(2)} GB';
  } else if (mbSize >= 1) {
    return '${mbSize.toStringAsFixed(2)} MB';
  } else if (kbSize >= 1) {
    return '${kbSize.toStringAsFixed(2)} KB';
  } else {
    return '$sizeInBytes bytes';
  }
}

/* ----------------------- Download and save audio OST ---------------------- */
Future<void> downloadAndSaveAudioOst(
    String audioUrl, String fileName, String folder) async {
  try {
    var response = await http.get(Uri.parse(audioUrl));
    if (response.statusCode == 200) {
      Directory imageFolder =
          Directory('${Constants.appDocumentsDirectory.path}$folder');

      // Create the directory if it doesn't exist
      if (!imageFolder.existsSync()) {
        imageFolder.createSync(recursive: true);
      }

      final file = File('${imageFolder.path}$fileName');
      await file.writeAsBytes(response.bodyBytes);
      //print('Imagen guardada en: ${file.path}');
    } else {
      print('Error al descargar el audio: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

/* ------ Download and Save Image from URL, custom filename and folder ------ */
Future<void> downloadAndSaveImage(
    String imageUrl, String fileName, String folder) async {
  try {
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      Directory imageFolder =
          Directory('${Constants.appDocumentsDirectory.path}$folder');

      // Create the directory if it doesn't exist
      if (!imageFolder.existsSync()) {
        imageFolder.createSync(recursive: true);
      }

      final file = File('${imageFolder.path}$fileName');
      await file.writeAsBytes(response.bodyBytes);
      //print('Imagen guardada en: ${file.path}');
    } else {
      print('Error al descargar la imagen: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

/* ----------------- Generates a random alphanumeric string ----------------- */
String generateRandomAlphanumeric() {
  final random = Random();
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';

  String randomString = '';
  for (int i = 0; i < 6; i++) {
    int randomIndex = random.nextInt(characters.length);
    randomString += characters[randomIndex];
  }

  return randomString;
}

/* -------------- Splits a list of platforms from each emulator ------------- */
/* ------------------- into a table and removes duplicates ------------------ */
List<String> getUniquePlatforms(List<Emulators> emulatorsList) {
  // Crear una lista para almacenar todas las plataformas
  List<String> platformList = [];

  // Iterar a través de la lista de emuladores y agregar sus plataformas a la lista
  for (Emulators emulator in emulatorsList) {
    List<String> platforms = emulator.systems.split(',');
    // Eliminar espacios en blanco al principio y al final de cada valor
    platforms = platforms.map((platform) => platform.trim()).toList();
    // Agregar las plataformas a la lista principal
    platformList.addAll(platforms);
  }

  // Eliminar duplicados
  platformList = platformList.toSet().toList();

  platformList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  return platformList;
}

/* ----------------------------- Creates a Slug ----------------------------- */
String createSlug(String input) {
  // Convierte la cadena a minúsculas
  String lowerCase = input.toLowerCase();

  // Utiliza RegExp para encontrar todos los caracteres que no son letras ni números
  final regex = RegExp(r'[^a-z0-9]');

  // Reemplaza los caracteres especiales y espacios por guiones
  String cleanedString = lowerCase.replaceAll(regex, '-');

  // Elimina guiones duplicados
  cleanedString = cleanedString.replaceAll(RegExp(r'-+'), '-');

  // Elimina guiones al principio y al final
  cleanedString = cleanedString.replaceAll(RegExp(r'^-|-$'), '');

  return cleanedString;
}

/* ----------------------------- Creates a Search String for Khinsider----------------------------- */
String createSearchString(String input) {
  // Convierte la cadena a minúsculas
  String lowerCase = input.toLowerCase();

  // Utiliza RegExp para encontrar todos los caracteres que no son letras ni números
  final regex = RegExp(r'[^a-z0-9]');

  // Replace special characters and spaces with plus
  String cleanedString = lowerCase.replaceAll(regex, '+');

  // Elimina guiones duplicados
  cleanedString = cleanedString.replaceAll(RegExp(r'-+'), '-');

  // Elimina guiones al principio y al final
  cleanedString = cleanedString.replaceAll(RegExp(r'^-|-$'), '');

  return cleanedString;
}

Future<List<EmulatorDownloadResponse>> selectEmulatorScrapper(
    String emulator, String url) async {
  DioClient dioClient = DioClient();
  late List<EmulatorDownloadResponse> response;
  switch (emulator) {
    case 'BSNES':
      response = await dioClient.bsnesScrapper(url: url);
      break;
    case 'Dolphin':
      response = await dioClient.dolphinScrapper(url: url);
      break;
    case 'Redream':
      response = await dioClient.redreamScrapper(url: url);
      break;
    case 'SNES9X':
      response = await dioClient.snes9xScrapper(url: url);
      break;
  }
  return response;
}

/* ----------------------- Updates progress bar value ----------------------- */
void updateProgress(int currentCount, int totalGames) {
  double progress = currentCount / totalGames;
  Constants.importProgress = progress;
}
