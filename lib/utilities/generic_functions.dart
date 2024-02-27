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
import 'package:provider/provider.dart';
import 'package:win32_registry/win32_registry.dart';

/* -------------------- Converts a color from ARGB to Hex ------------------- */
/// The function `colorToHex` converts a Color object to a hexadecimal string representation.
/// 
/// Args:
///   color (Color): The `color` parameter in the `colorToHex` function is of type `Color`. It
/// represents a color value that can be used to convert to a hexadecimal representation.
/// 
/// Returns:
///   The function `colorToHex` takes a `Color` object as input and returns a hexadecimal representation
/// of the color value. The returned value is a string that starts with '#' followed by the hexadecimal
/// representation of the color value.
String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0')}';
}

/* -------------------------- Converts Hex to ARGB -------------------------- */
/// The function `hexToColor` converts a hexadecimal color code to a Dart Color object, ensuring it
/// includes an alpha value if missing.
/// 
/// Args:
///   code (String): The `code` parameter in the `hexToColor` function is a string representing a color
/// in hexadecimal format. This function converts the hexadecimal color code to a Color object that can
/// be used in Flutter or other similar frameworks.
/// 
/// Returns:
///   The method `hexToColor` is returning a Color object based on the hexadecimal color code provided
/// as a parameter. The method first removes the "#" symbol from the code, then checks if the code
/// length is 6. If the length is 6, it adds "FF" at the beginning to represent the alpha value.
/// Finally, it parses the hexadecimal code to an integer value and creates a Color
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
/// The function `hexToColorWithAlpha` converts a hexadecimal color code to a Color object with a
/// specified alpha value.
/// 
/// Args:
///   code (String): The `code` parameter is a hexadecimal color code represented as a string, typically
/// starting with a `#` symbol.
///   alpha (int): The `alpha` parameter in the `hexToColorWithAlpha` function represents the alpha
/// value of the color, which determines the transparency of the color. It ranges from 0 (completely
/// transparent) to 255 (completely opaque).
/// 
/// Returns:
///   The function `hexToColorWithAlpha` takes a hexadecimal color code as a string and an alpha value
/// as an integer. It converts the hexadecimal color code to a Color object with the specified alpha
/// value and returns the Color object.
Color hexToColorWithAlpha(String code, int alpha) {
  code = code.replaceAll("#", "");
  int value = int.parse(code, radix: 16);
  return Color.fromARGB(
      alpha, value >> 16 & 0xFF, value >> 8 & 0xFF, value & 0xFF);
}

/* ----Choose a text color depending on the background color, to make it stand out. */
/// The function `determineTextColor` calculates the luminance of a background color and returns either
/// black or white text color based on the background's darkness.
/// 
/// Args:
///   backgroundColor (Color): The `backgroundColor` parameter is the color for which you want to
/// determine whether the text color should be dark or light. The function calculates the luminance of
/// this background color and compares it against a threshold to decide whether to use black or white
/// text color for better contrast and readability.
/// 
/// Returns:
///   either `Colors.black` or `Colors.white` based on whether the background color is considered dark
/// enough to use light text.
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
/// The `deleteFile` function deletes a file if it exists, otherwise it prints a message indicating that
/// the file does not exist.
/// 
/// Args:
///   fileName (String): The `deleteFile` function takes a `String` parameter `fileName`, which
/// represents the name of the file that needs to be deleted.
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
/// The function `stringToSeconds` converts a string representing minutes and seconds into total
/// seconds.
/// 
/// Args:
///   value (String): The `stringToSeconds` function you provided takes a string input in the format
/// "minutes:seconds" and converts it into total seconds. If the input string does not match the
/// expected format, it returns 0.
/// 
/// Returns:
///   The function `stringToSeconds` returns the total time in seconds calculated from the input string
/// value in the format "minutes:seconds". If the input string can be successfully split into two parts
/// (minutes and seconds), it calculates the total time in seconds and returns that value. If the input
/// string does not have the expected format, it returns 0 or a default value.
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
/// The `deleteDirectory` function deletes a directory at the specified path if it exists.
/// 
/// Args:
///   folderPath (String): The `folderPath` parameter in the `deleteDirectory` function is a string that
/// represents the path to the directory that you want to delete. It is the location of the directory on
/// the file system that you want to remove.
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
/// The function `deleteFilesFromFolder` deletes specified files from a given folder path in Dart.
/// 
/// Args:
///   folderPath (String): The `folderPath` parameter is a string that represents the path to the folder
/// from which you want to delete files. It should be a valid path to a directory on the file system.
///   files (List<String>): A list of file names that you want to delete from the specified folder.
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
/// The function `detectDominantColor` takes an image URL, extracts a region from the image, and returns
/// the dominant color within that region using the PaletteGenerator class from the Flutter SDK.
/// 
/// Args:
///   imageUrl (String): The `imageUrl` parameter in the `detectDominantColor` function is a string that
/// represents the location or path of the image file from which you want to detect the dominant color.
/// It could be a local file path on the device or a URL pointing to an image on the web.
/// 
/// Returns:
///   The function `detectDominantColor` returns a `Future<Color>` which represents the dominant color
/// extracted from a specified region of the image located at the given `imageUrl`. If the image file
/// does not exist or if there are any errors during the color detection process, the function returns
/// the default color `Colors.white`.
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
/// The function `formatMinutesToHMS` converts total minutes into hours, minutes, and seconds format.
/// 
/// Args:
///   totalMinutes (int): The `formatMinutesToHMS` function takes an integer `totalMinutes` as input,
/// which represents the total number of minutes. The function then calculates the equivalent hours,
/// minutes, and seconds based on the total minutes provided and returns a formatted string in the
/// format "Xh Ym Zs
/// 
/// Returns:
///   The function `formatMinutesToHMS` takes a total number of minutes as input and calculates the
/// equivalent hours and minutes. It then returns a string in the format "Xh Ym Zs" where X is the
/// hours, Y is the minutes, and Z is the seconds (which is always 0 in this case).
String formatMinutesToHMS(int totalMinutes) {
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;
  int seconds = 0; // Inicialmente establecido en cero segundos

  return '${hours.toString()}h  ${minutes.toString()}m  ${seconds.toString()}s';
}

/* ------------ Converts a database date to local readable format ----------- */
/// The function `formatDateString` takes a date string as input, converts it to a DateTime object, and
/// then formats it in the 'd MMMM y' (day month year) format in Spanish.
/// 
/// Args:
///   dateString (String): The `dateString` parameter is a string representing a date in a specific
/// format that can be parsed into a `DateTime` object.
/// 
/// Returns:
///   The function `formatDateString` takes a `dateString` as input, converts it to a `DateTime` object,
/// formats it using the 'd MMMM y' pattern in Spanish locale, and returns the formatted date as a
/// string.
String formatDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('d MMMM y', 'es').format(dateTime);
  return formattedDate;
}

/* --------------------------- Convert int to bool -------------------------- */
/// The function `convertIntBool` converts an integer value to a boolean value, returning `false` if the
/// integer is 0 and `true` otherwise.
/// 
/// Args:
///   value (int): The parameter `value` is of type `int?`, which means it is a nullable integer. This
/// allows the value to be either an integer or `null`.
/// 
/// Returns:
///   `true` if the `value` is not equal to 0, and `false` if the `value` is equal to 0.
bool convertIntBool(int? value) {
  if (value == 0) return false;
  return true;
}

/* --------------------------- Convert bool to int -------------------------- */
/// The function `convertBoolInt` converts a boolean value to an integer, returning 1 if the value is
/// true and 0 otherwise.
/// 
/// Args:
///   value (bool): The parameter `value` is of type `bool?`, which means it is a nullable boolean
/// value. It can hold a boolean value (`true` or `false`) or be `null`.
/// 
/// Returns:
///   If the `value` is `true`, the function will return `1`. Otherwise, it will return `0`.
int convertBoolInt(bool? value) {
  if (value == true) return 1;
  return 0;
}

/* ----------------------- Check if asset loads or not ---------------------- */
/// The function `checkAssetLoading` attempts to load an asset using `rootBundle.load` in Dart and
/// prints a message based on the success or failure of the loading process.
/// 
/// Args:
///   assetPath (String): The `assetPath` parameter is a string that represents the path to the asset
/// that you want to load and check. It should be the path to the asset file within your project's
/// assets folder. For example, if you have an image file named `image.png` located in the `assets`
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

/// This Dart function checks if a specified Windows application is installed by looking for its
/// registry key and returns a boolean value after a specified delay.
/// 
/// Args:
///   appName (String): The `appName` parameter is a string that represents the name of the application
/// you want to check if it is installed on the system.
///   delay (int): The `delay` parameter in the `checkIfAppInstalled` function represents the amount of
/// time, in seconds, that the function will wait before returning the result of whether the specified
/// `appName` is installed on the system. This delay is achieved using `Future.delayed(Duration(seconds:
/// delay))`
/// 
/// Returns:
///   A Future<bool> is being returned.
Future<Map<String, dynamic>?> checkIfAppInstalled(String appName, int delay) async {
  bool isInstalled = false;
  try {
    var keyPath =
        r'Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\' +
            appName;
    final key = Registry.openPath(RegistryHive.localMachine, path: keyPath);

    final keyValue = key.getValueAsString('InstallLocation');

    if (keyValue != '') {
      print('The application is installed');
      isInstalled = true;
    } else {
      print('The application is not installed');
      isInstalled = false;
    }
    key.close();
    await Future.delayed(Duration(seconds: delay));
    return {'isInstalled': isInstalled, 'location': keyValue};
  } catch (e) {
    return null;
  }
}

/* ---------------- Processes an array of screenshots when downloading them ---------------- */
/// The function `processScreenshots` downloads an image from a given URL and saves it to a specified
/// folder with a given file name.
/// 
/// Args:
///   imageUrl (String): The `imageUrl` parameter is the URL of the image that you want to download and
/// save locally. It is used to fetch the image data from the internet using an HTTP GET request.
///   fileName (String): The `fileName` parameter in the `processScreenshots` function is a `String`
/// variable that represents the name of the file to which the downloaded image will be saved. It is
/// used to specify the name of the file in which the image data will be written.
///   folder (String): The `folder` parameter in the `processScreenshots` function represents the
/// directory path where the downloaded image will be saved. It is a string that specifies the folder
/// within the app's documents directory where the image file will be stored. For example, if `folder`
/// is "screenshots/", the
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
/// The `downloadFile` function downloads a file from a given URL and saves it to a specified directory
/// on the device.
/// 
/// Args:
///   url (String): The `url` parameter in the `downloadFile` function is the URL from which you want to
/// download a file. It is a string representing the location of the file you want to download from the
/// internet.
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
/// The function `formatFileSize` converts a file size in bytes to a human-readable format in KB, MB,
/// GB, or bytes.
/// 
/// Args:
///   sizeInBytes (int): The function `formatFileSize` takes an integer `sizeInBytes` as input and
/// converts it into a human-readable file size format. It calculates the size in kilobytes (KB),
/// megabytes (MB), or gigabytes (GB) based on the input size in bytes.
/// 
/// Returns:
///   The function `formatFileSize` takes an integer `sizeInBytes` as input and calculates the size in
/// kilobytes (kb), megabytes (mb), or gigabytes (gb) based on the input size. It then returns a
/// formatted string representing the size in the appropriate unit.
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
/// The function `downloadAndSaveAudioOst` downloads an audio file from a given URL and saves it to a
/// specified folder with a specified file name.
/// 
/// Args:
///   audioUrl (String): The `audioUrl` parameter is the URL of the audio file that you want to download
/// and save.
///   fileName (String): The `fileName` parameter in the `downloadAndSaveAudioOst` function is a
/// `String` that represents the name of the file to which the audio content will be saved. It is used
/// to specify the name of the audio file that will be downloaded and stored in the specified folder.
///   folder (String): The `folder` parameter in the `downloadAndSaveAudioOst` function represents the
/// directory where the audio file will be saved. It is a string that specifies the path to the folder
/// where you want to save the audio file. For example, if you want to save the audio file in a
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
/// This Dart function downloads an image from a given URL and saves it to a specified folder with a
/// given file name.
/// 
/// Args:
///   imageUrl (String): The `imageUrl` parameter is a String that represents the URL from which the
/// image will be downloaded.
///   fileName (String): The `fileName` parameter in the `downloadAndSaveImage` function is a `String`
/// that represents the name of the file under which the downloaded image will be saved. It is used to
/// specify the name of the file in which the image data will be written.
///   folder (String): The `folder` parameter in the `downloadAndSaveImage` function represents the
/// directory where the image will be saved. It is a string that specifies the path to the folder where
/// the image will be stored on the device. For example, if you provide "images/" as the `folder`
/// parameter
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
/// This Dart function generates a random 4-character alphanumeric string.
/// 
/// Returns:
///   A randomly generated alphanumeric string of length 4 is being returned.
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
/// The function `getUniquePlatforms` takes a list of Emulators, extracts their platforms, removes
/// duplicates, and returns a sorted list of unique platforms.
/// 
/// Args:
///   emulatorsList (List<Emulators>): A list of Emulators objects, where each Emulators object has a
/// property `systems` that contains a comma-separated list of platform names. The `getUniquePlatforms`
/// function extracts all unique platform names from the `systems` property of each Emulators object in
/// the input list and returns a sorted list
/// 
/// Returns:
///   The method `getUniquePlatforms` returns a `List<String>` containing unique platform names
/// extracted from the list of `Emulators` provided as input. The platform names are sorted in
/// alphabetical order, ignoring case sensitivity.
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
/// The function `createSearchString` takes an input string, converts it to lowercase, replaces special
/// characters and spaces with plus, removes duplicate dashes, and trims dashes from the beginning and
/// end before returning the modified string.
/// 
/// Args:
///   input (String): The `createSearchString` function takes a string input, converts it to lowercase,
/// replaces special characters and spaces with a plus sign, removes duplicate hyphens, and removes
/// hyphens at the beginning and end of the string. The resulting string is then returned.
/// 
/// Returns:
///   The function `createSearchString` takes an input string, converts it to lowercase, replaces
/// special characters and spaces with plus sign, removes duplicate dashes, and removes dashes at the
/// beginning and end of the string. The cleaned string is then returned.
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
/// The `updateProgress` function updates the importing progress and game name in the app state based on
/// the current count, total games, and name provided.
/// 
/// Args:
///   appState (AppState): App state object that contains the current state of the application,
/// including importing progress and game information.
///   currentCount (int): The `currentCount` parameter represents the number of games that have been
/// processed/imported so far.
///   totalGames (int): The `totalGames` parameter represents the total number of games that need to be
/// processed or imported.
///   name (String): The `name` parameter in the `updateProgress` function represents the name of the
/// game that is currently being processed or imported.
void updateProgress(
    AppState appState, int currentCount, int totalGames, String name) {
  double progress = currentCount / totalGames;
  appState.setImportingProgress(progress);
  appState.setImportingGame(name);
}
