import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl =
      'https://tu-backend.com/api'; // Cambia esto por tu URL real

  /// GET automatizado con token
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'),
        headers: await _headers());
    return _processResponse(response);
  }

  /// POST automatizado con token
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  /// PUT automatizado con token
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  /// DELETE automatizado con token
  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'),
        headers: await _headers());
    return _processResponse(response);
  }

  /// Headers con token automático
  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Procesa las respuestas del servidor
  static dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
