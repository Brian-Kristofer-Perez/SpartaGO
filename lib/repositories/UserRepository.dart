import 'dart:convert';
import '../Helpers/LocalFileHelper.dart';

class UserRepository {
  final String _fileName = 'users.json';

  Future<List<Map<String, dynamic>>> _loadData() async {
    final file = await LocalFileHelper.initializeJsonFile(_fileName);
    final contents = await file.readAsString();
    return List<Map<String, dynamic>>.from(jsonDecode(contents));
  }

  Future<void> _saveData(List<Map<String, dynamic>> data) async {
    final file = await LocalFileHelper.initializeJsonFile(_fileName);
    await file.writeAsString(jsonEncode(data));
  }

  Future<List<Map<String, dynamic>>> getAll() async => await _loadData();

  Future<Map<String, dynamic>?> getByEmail(String email) async {
    final data = await _loadData();
    final user = data.firstWhere(
          (u) => u['email'] == email,
      orElse: () => {},
    );
    return user.isEmpty ? null : user;
  }

  Future<void> add(Map<String, dynamic> user) async {
    final data = await _loadData();

    if (data.any((u) => u['email'] == user['email'])) {
      throw Exception('User with email ${user['email']} already exists');
    }

    data.add(user);
    await _saveData(data);
  }
}
