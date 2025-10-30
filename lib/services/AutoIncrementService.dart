import 'dart:convert';
import 'dart:io';
import '../Helpers/LocalFileHelper.dart';


class AutoIncrementService {
  final String filename = 'autoincrement_data.json';

  /// Loads the counter data from the writable JSON file
  Future<Map<String, dynamic>> _loadData() async {
    final path = await LocalFileHelper.getFilePath(filename);
    final file = File(path);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode({
        "equipment": 0,
        "facility": 0,
        "equipment_reservation": 0,
        "facility_reservation": 0
      }));
    }

    final contents = await file.readAsString();
    return jsonDecode(contents);
  }

  /// Saves updated counter data
  Future<void> _saveData(Map<String, dynamic> data) async {
    final path = await LocalFileHelper.getFilePath(filename);
    final file = File(path);
    await file.writeAsString(jsonEncode(data));
  }

  /// Returns the next auto-increment ID for a given key
  Future<int> getNextId(String key) async {
    final data = await _loadData();

    if (!data.containsKey(key)) {
      data[key] = 0;
    }

    data[key] = (data[key] as int) + 1;
    await _saveData(data);

    return data[key];
  }

  /// Optional helper to reset all counters to 0
  Future<void> resetAll() async {
    final data = {
      "equipment": 0,
      "facility": 0,
      "equipment_reservation": 0,
      "facility_reservation": 0
    };
    await _saveData(data);
  }
}
