import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;
  AuthService({required this.baseUrl});

  Future<http.Response> register(String username, String password) {
    final url = Uri.parse('$baseUrl/register');
    return http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));
  }

  Future<http.Response> login(String username, String password) {
    final url = Uri.parse('$baseUrl/login');
    return http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));
  }
}
