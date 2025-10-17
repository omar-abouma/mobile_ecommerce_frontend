import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000";
  
  // Register method
  static Future<Map<String, dynamic>> register({
    required String username,
    required String firstName,
    required String secondName,
    required String sirName,
    required String email,
    required String phone,
    required String dob,
    required String street,
    required String houseNumber,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/flutter_app/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'first_name': firstName,
        'second_name': secondName,
        'sir_name': sirName,
        'email': email,
        'phone': phone,
        'dob': dob,
        'street': street,
        'house_number': houseNumber,
        'password': password,
        'confirm_password': confirmPassword,
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Registration successful'};
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData.values.map((e) => e.toString()).join('\n'));
    }
  }

  // Login method
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/flutter_app/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Login failed');
    }
  }

  // Save tokens
  static Future<void> saveTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', data['access']);
    await prefs.setString('refresh_token', data['refresh']);
    await prefs.setString('username', data['username']);
    await prefs.setString('email', data['email']);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') != null;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('username');
    await prefs.remove('email');
  }
}