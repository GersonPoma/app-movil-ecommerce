import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loginUrl =
      'https://tu-backend.com/api/usuarios/login/'; // Cambia por tu URL real

  /// Login de usuario
  static Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      await prefs.setString('user_role', data['rol']);
    } else {
      throw Exception('Credenciales inválidas: ${response.body}');
    }
  }

  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Verifica si el usuario está logueado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') != null;
  }

  /// Obtiene el rol del usuario autenticado
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  /// Obtiene el token actual
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
