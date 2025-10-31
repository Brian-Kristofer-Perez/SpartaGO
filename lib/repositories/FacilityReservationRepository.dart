import 'dart:convert';
import '../Helpers/LocalFileHelper.dart';

class FacilityReservationRepository {
  final String _fileName = 'facility_reservations.json';

  /// Load reservation data from storage
  Future<List<Map<String, dynamic>>> _loadData() async {
    final file = await LocalFileHelper.initializeJsonFile(_fileName);
    final contents = await file.readAsString();
    if (contents.isEmpty) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(contents));
  }

  /// Save reservation data to storage
  Future<void> _saveData(List<Map<String, dynamic>> data) async {
    final file = await LocalFileHelper.initializeJsonFile(_fileName);
    await file.writeAsString(jsonEncode(data));
  }

  Future<List<Map<String, dynamic>>> getAll() async => await _loadData();

  Future<Map<String, dynamic>?> getById(String id) async {
    final data = await _loadData();
    final reservation = data.firstWhere((r) => r['id'] == id, orElse: () => {});
    return reservation.isEmpty ? null : reservation;
  }

  Future<void> add(Map<String, dynamic> reservation) async {
    final data = await _loadData();
    if (data.any((r) => r['id'] == reservation['id'])) {
      throw Exception('Reservation with id ${reservation['id']} already exists');
    }
    data.add(reservation);
    await _saveData(data);
  }

  Future<bool> update(String id, Map<String, dynamic> updatedFields) async {
    final data = await _loadData();
    final index = data.indexWhere((r) => r['id'] == id);
    if (index == -1) return false;

    data[index] = {...data[index], ...updatedFields, 'id': id};
    await _saveData(data);
    return true;
  }

  Future<bool> delete(String id) async {
    final data = await _loadData();
    final index = data.indexWhere((r) => r['id'] == id);
    if (index == -1) return false;

    data.removeAt(index);
    await _saveData(data);
    return true;
  }
}
