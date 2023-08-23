import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../widgets/platform_tree_view.dart';
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

/* ------ Download and Save Image from URL, custom filename and folder ------ */
Future<void> downloadAndSaveImage(
    String imageUrl, String fileName, String folder) async {
  try {
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      Directory imageFolder = Directory('${appDocumentsDirectory.path}$folder');

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

/* ----------------------- Updates progress bar value ----------------------- */
void updateProgress(int currentCount, int totalGames) {
  double progress = currentCount / totalGames;
  Constants.importProgress = progress;
}
