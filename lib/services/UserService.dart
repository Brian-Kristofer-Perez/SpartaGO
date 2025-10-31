import 'package:sparta_go/services/AutoIncrementService.dart';

import '../Repositories/UserRepository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();

  // Register a user
  Future<void> register({
    required String name,
    required String email,
    required String studentNumber,
    required String password,
  }) async {
    final users = await _userRepository.getAll();
    final nextId = users.isEmpty ? 1 : (users.last['id'] ?? users.length) + 1;

    // check if user already exists
    final existingUser = await _userRepository.getByEmail(email);
    if (existingUser != null) {
      throw Exception('Email already registered');
    }

    // save new user
    final user = {
      'id': await AutoIncrementService().getNextId('student'),
      'name': name,
      'email': email,
      'studentNumber': studentNumber,
      'password': password,
    };

    await _userRepository.add(user);
  }

  // logs in a user by verifying email and password
  Future<Map<String, dynamic>> log_in({
    required String email,
    required String password,
  }) async {
    final user = await _userRepository.getByEmail(email);
    if (user == null) {
      throw Exception('User not found');
    }

    if (user['password'] != password) {
      throw Exception('Invalid password');
    }

    return user;
  }
}
