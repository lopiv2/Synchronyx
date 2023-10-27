import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppDirectories {
  late Directory appDocumentsDirectory;
  
  AppDirectories._privateConstructor();
  static final AppDirectories instance = AppDirectories._privateConstructor();
  
  Future<void> initialize() async {
    try {
      appDocumentsDirectory = await getApplicationDocumentsDirectory();
      /*print(
          'appDocumentsDirectory initialized to: ${appDocumentsDirectory.path}');*/
    } catch (e) {
      print('Error initializing appDocumentsDirectory: $e');
    }
  }
}
