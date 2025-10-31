import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class LocalFileHelper {
  // Copies an asset JSON file to the writable directory.
  static Future<File> initializeJsonFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    // Copy from assets if it doesn't exist yet
    if (!(await file.exists())) {
      final data = await rootBundle.loadString('assets/files/$filename');
      await file.create(recursive: true);
      await file.writeAsString(data);
    }

    return file;
  }

  // Returns the file path in the writable directory (and ensures it's initialized).
  static Future<String> getFilePath(String filename) async {
    final file = await initializeJsonFile(filename);
    return file.path;
  }

  // Deletes the writable directory and all its contents.
  static Future<void> resetStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);
  }

  // Recreates all JSONs after a reset.
  // Pass a list of filenames (e.g., ['equipment.json', 'facility.json'])
  static Future<void> reinitializeFiles(List<String> filenames) async {
    for (final name in filenames) {
      await initializeJsonFile(name);
    }
  }
}
