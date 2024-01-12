import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiManager {
  final String baseUrl;
  final storage = FlutterSecureStorage();

  ApiManager({required this.baseUrl});

  //membuat fungsi memanggil api login.php
  Future<String?> authenticate(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];

      // Save the token securely
      await storage.write(key: 'auth_token', value: token);

      return token;
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  //membuat fungsi memanggil api register.php
  Future<void> register(String name, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': username, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register ${response.statusCode}');
    }
  }

  Future<void> sendFilmData(String judul, String deskripsi) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/film'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'judul': judul, 'deskripsi': deskripsi}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register ${response.statusCode}');
    }
  }

  Future<void> UpdateFilmData(String judul, String deskripsi, String id) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/films'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'id': id, 'judul': judul, 'deskripsi': deskripsi}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register ${response.statusCode}');
    }
  }

  Future<void> DeleteFilmData(String id) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register ${response.statusCode}');
    }
  }

  //membuat fungsi memanggil api list user atau crud.php
  Future<Map<String, dynamic>> GetFilms() async {
    final token = await storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to get users');
    }
  }
}
