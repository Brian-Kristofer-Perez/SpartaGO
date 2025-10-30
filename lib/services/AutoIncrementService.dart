import 'dart:convert';
import 'dart:io';

class AutoIncrementService {
  final String filePath = 'assets/files/autoincrement_data.json';

  Future<Map<String, dynamic>> _loadData() async {
    final file = File(filePath);

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

  Future<void> _saveData(Map<String, dynamic> data) async {
    final file = File(filePath);
    await file.writeAsString(jsonEncode(data));
  }

  Future<int> getNextId(String key) async {
    final data = await _loadData();

    if (!data.containsKey(key)) {
      data[key] = 0;
    }

    data[key] = (data[key] as int) + 1;
    await _saveData(data);

    return data[key];
  }
}
