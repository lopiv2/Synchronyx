import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:lioncade/models/emulators.dart';
import 'package:lioncade/models/responses/emulator_download_response.dart';
import 'package:lioncade/utilities/app_directory_singleton.dart';
import 'package:lioncade/utilities/generic_api_functions.dart';
import 'package:win32_registry/win32_registry.dart';

/* -------------------- Converts a color from ARGB to Hex ------------------- */
String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0')}';
}

/* -------------------------- Converts Hex to ARGB -------------------------- */
Color hexToColor(String code) {
  code = code.replaceAll("#", "");
  if (code.length == 6) {
    code = "FF" +
        code; // Añade el valor alfa (alpha) FF si no está presente en el código hexadecimal
  }
  int value = int.parse(code, radix: 16);
  return Color(value);
}

/* ----------------- Applies alpha and converts Hex to ARGB ----------------- */
Color hexToColorWithAlpha(String code, int alpha) {
  code = code.replaceAll("#", "");
  int value = int.parse(code, radix: 16);
  return Color.fromARGB(
      alpha, value >> 16 & 0xFF, value >> 8 & 0xFF, value & 0xFF);
}

/* ----Choose a text color depending on the background color, to make it stand out. */
Color determineTextColor(Color backgroundColor) {
  // Calculates the luminance of the background color
  final backgroundLuminance = (0.299 * backgroundColor.red +
          0.587 * backgroundColor.green +
          0.114 * backgroundColor.blue) /
      255;

  // Defines a luminance threshold to determine whether the text color should be dark or light
  const luminanceThreshold =
      0.5; // You can adjust this value according to your preferences

  // Checks if the background color is dark enough to use light text
  return backgroundLuminance > luminanceThreshold ? Colors.black : Colors.white;
}

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

/* ------- Detects the dominant color of a local image, and returns it ------- */
Future<Color> detectDominantColor(String imageUrl) async {
  File image = File(imageUrl); // Or any other way to get a File instance.
  if (!await image.exists()) {
    // Manejar el caso en el que el archivo de imagen no existe.
    return Colors.white; // Color predeterminado en caso de error.
  }

  var decodedImage = await decodeImageFromList(image.readAsBytesSync());

  final double centerX = decodedImage.width / 2;
  final double centerY = decodedImage.height / 2;
  const double regionSize = 50.0; // Tamaño de la región (en píxeles).

  final double left = centerX - (regionSize / 2);
  final double top = centerY - (regionSize / 2);
  final double right = centerX + (regionSize / 2);
  final double bottom = centerY + (regionSize / 2);

  if (left < 0 ||
      top < 0 ||
      right > decodedImage.width ||
      bottom > decodedImage.height) {
    // Asegurarse de que la región no se encuentre fuera de los límites de la imagen.
    return Colors.white; // Color predeterminado en caso de error.
  }

  final Rect region = Rect.fromPoints(Offset(left, top), Offset(right, bottom));

  final paletteGenerator = await PaletteGenerator.fromImage(
    decodedImage,
    region: region,
  );

  final Color dominantColor = paletteGenerator.dominantColor!.color;

  return dominantColor;
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

/* --------------------------- Convert bool to int -------------------------- */
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

/* ------------------ Check if app is installed in Registry ----------------- */

Future<bool> checkIfAppInstalled(String appName) async {
  bool isInstalled = false;
  try {
    var keyPath =
        r'Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\' +
            appName;
    final key = Registry.openPath(RegistryHive.localMachine, path: keyPath);

    final keyValue = key.getValueAsString('DisplayName');

    if (keyValue != '') {
      print('The application is installed');
      isInstalled = true;
    } else {
      print('The application is not installed');
      isInstalled = false;
    }
    key.close();
    return isInstalled;
  } catch (e) {
    return false;
  }
}

/* ---------------- Processes an array of screenshots when downloading them ---------------- */
Future<void> processScreenshots(
    String imageUrl, String fileName, String folder) async {
  try {
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      Directory imageFolder = Directory(
          '${AppDirectories.instance.appDocumentsDirectory.path}$folder');

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

/* -------------------------- Download file from URL ------------------------- */
Future<void> downloadFile(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String folder = '\\Lioncade\\downloads\\';
      List<String> parts = url.split("/");
      String fileName = parts.last;
      //await Constants.initialize();
      Directory fileFolder = Directory(
          '${AppDirectories.instance.appDocumentsDirectory.path}$folder');

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
      Directory imageFolder = Directory(
          '${AppDirectories.instance.appDocumentsDirectory.path}$folder');

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
      Directory imageFolder = Directory(
          '${AppDirectories.instance.appDocumentsDirectory.path}$folder');

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
  for (int i = 0; i < 4; i++) {
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
void updateProgress(
    AppState appState, int currentCount, int totalGames, String name) {
  double progress = currentCount / totalGames;
  appState.setImportingProgress(progress);
  appState.setImportingGame(name);
}
