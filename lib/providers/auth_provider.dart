import 'package:flutter/material.dart';
import 'package:novindus/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _token;
  String? _error;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get error => _error;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await AuthService().login(username, password);
      _token = result['token'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
