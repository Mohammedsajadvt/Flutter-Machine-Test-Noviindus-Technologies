import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novindus/core/constants/app_constants.dart';

class AuthService {
  Future<dynamic> login(String username, String password) async {
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.loginEndpoint);
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      } else {
        throw data['message'] ?? 'Login failed';
      }
    } else {
      throw 'Network error: ${response.statusCode}';
    }
  }
}
