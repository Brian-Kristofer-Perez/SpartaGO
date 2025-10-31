import 'dart:convert';
import '../Helpers/LocalFileHelper.dart';

class FacilityRepository {
  final String _fileName = 'facilities.json';

  /// Load facility data from storage
  Future<List<Map<String, dynamic>>> _loadData() async {
    final file = await LocalFileHelper.initializeJsonFile(_fileName);
    final contents = await file.readAsString();
    if (contents.isEmpty) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(contents));
  }

  /// Save facility data to storage
  Future<void> _saveData(List<Map<String, dynamic>> data) async {
    final file = await LocalFileHelper.initializeJsonFile(_fileName);
    await file.writeAsString(jsonEncode(data));
  }

  Future<List<Map<String, dynamic>>> getAll() async => await _loadData();

  Future<Map<String, dynamic>?> getById(int id) async {
    final data = await _loadData();
    final item = data.firstWhere((f) => f['id'] == id, orElse: () => {});
    return item.isEmpty ? null : item;
  }

  Future<void> add(Map<String, dynamic> facility) async {
    final data = await _loadData();
    if (data.any((f) => f['id'] == facility['id'])) {
      throw Exception('Facility with id ${facility['id']} already exists');
    }
    data.add(facility);
    await _saveData(data);
  }

  Future<bool> update(int id, Map<String, dynamic> updatedFields) async {
    final data = await _loadData();
    final index = data.indexWhere((f) => f['id'] == id);
    if (index == -1) return false;

    data[index] = {...data[index], ...updatedFields, 'id': id};
    await _saveData(data);
    return true;
  }

  Future<bool> delete(int id) async {
    final data = await _loadData();
    final index = data.indexWhere((f) => f['id'] == id);
    if (index == -1) return false;

    data.removeAt(index);
    await _saveData(data);
    return true;
  }
}
