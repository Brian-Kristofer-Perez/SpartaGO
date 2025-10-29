import 'dart:convert';
import 'dart:io';

class EquipmentRepository {
  final String filePath = 'assets/files/equipment.json';

  Future<List<Map<String, dynamic>>> _loadData() async {
    final file = File(filePath);
    if (!await file.exists()) {
      await file.writeAsString(jsonEncode([]));
    }
    final contents = await file.readAsString();
    return List<Map<String, dynamic>>.from(jsonDecode(contents));
  }

  Future<void> _saveData(List<Map<String, dynamic>> data) async {
    final file = File(filePath);
    await file.writeAsString(jsonEncode(data));
  }

  Future<List<Map<String, dynamic>>> getAll() async => await _loadData();

  Future<Map<String, dynamic>?> getById(String id) async {
    final data = await _loadData();
    final item = data.firstWhere((e) => e['id'] == id, orElse: () => {});
    return item.isEmpty ? null : item;
  }

  Future<void> add(Map<String, dynamic> item) async {
    final data = await _loadData();
    if (data.any((e) => e['id'] == item['id'])) {
      throw Exception('Equipment with id ${item['id']} already exists');
    }
    data.add(item);
    await _saveData(data);
  }

  Future<bool> update(String id, Map<String, dynamic> updatedFields) async {
    final data = await _loadData();
    final index = data.indexWhere((e) => e['id'] == id);
    if (index == -1) return false;

    data[index] = {...data[index], ...updatedFields, 'id': id};
    await _saveData(data);
    return true;
  }

  Future<bool> delete(String id) async {
    final data = await _loadData();
    final index = data.indexWhere((e) => e['id'] == id);
    if (index == -1) return false;

    data.removeAt(index);
    await _saveData(data);
    return true;
  }
}
