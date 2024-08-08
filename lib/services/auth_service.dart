import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();
  final String _userIdKey = 'userId';

  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // Check database login
    final dbUser = await _databaseService.getUserByEmail(email);
    if (dbUser != null) {
      final isPasswordCorrect = await _databaseService.checkPassword(email, password);
      if (isPasswordCorrect) {
        _currentUser = dbUser;
        await _saveUserId(dbUser.id);
        return true;
      }
    }

    return false;
  }

  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required int age,
    required String sex,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Check if email already exists in database
    final dbUser = await _databaseService.getUserByEmail(email);
    if (dbUser != null) {
      return false; // Email already exists in database
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
      name: name,
      username: username,
      email: email,
      age: age,
      sex: sex,
    );

    // Save user to database
    final success = await _databaseService.createUser(newUser, password);
    if (success) {
      _currentUser = newUser;
      await _saveUserId(newUser.id);
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    await _removeUserId();
  }

  Future<bool> isLoggedIn() async {
    if (_currentUser != null) return true;

    final userId = await _getUserId();
    if (userId != null) {
      final user = await _databaseService.getUserById(userId);
      if (user != null) {
        _currentUser = user;
        return true;
      }
    }
    return false;
  }

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> _removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  Future<void> loadUser() async {
    final userId = await _getUserId();
    if (userId != null) {
      _currentUser = await _databaseService.getUserById(userId);
    }
  }
}
