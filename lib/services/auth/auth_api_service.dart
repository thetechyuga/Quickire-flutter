import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/user.dart';
import 'package:quickhire/services/auth/auth_api_response.dart';

class AuthApiService {
  final storage = const FlutterSecureStorage();

  Future<AuthApiResponse> signup(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/signup/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> user = data['user'];
        await storage.write(key: 'token', value: data['token']);
        await storage.write(key: 'user_id', value: user['id'].toString());
        await storage.write(
            key: 'username', value: user['username'].toString());
        return AuthApiResponse(success: true);
      }
      final Map<String, dynamic> errorData = json.decode(response.body);
      String errorMessage = '';
      if (errorData.containsKey('username')) {
        errorMessage = (errorData['username'] as List).join(' ');
      } else if (errorData.containsKey('error')) {
        errorMessage = errorData['error'];
      } else {
        errorMessage = 'Failed to log you in. Try again Later!';
      }
      return AuthApiResponse(success: false, errorMessage: errorMessage);
    } catch (e) {
      return AuthApiResponse(success: false, errorMessage: e.toString());
    }
  }

  Future<AuthApiResponse> login(User user) async {
    try {
      print('$BASE_URL/user-login/');
      final response = await http.post(
        Uri.parse('$BASE_URL/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': user.username,
          'password': user.password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> user = data['user'];

        await storage.write(key: 'token', value: data['token']);
        await storage.write(key: 'user_id', value: user['id'].toString());
        await storage.write(
            key: 'username', value: user['username'].toString());

        bool receiveType = await getUserType(data['token'], user['id']);

        debugPrint(receiveType.toString());

        if (receiveType) {
          return AuthApiResponse(success: true);
        }
        return AuthApiResponse(success: false);
      }
      final Map<String, dynamic> errorData = json.decode(response.body);
      String errorMessage = errorData['detail'];

      if (errorMessage == "No User matches the given query.") {
        errorMessage = "User not found";
      }

      return AuthApiResponse(success: false, errorMessage: errorMessage);
    } catch (e) {
      return AuthApiResponse(success: false, errorMessage: e.toString());
    }
  }

  Future<AuthApiResponse> sendOTP(String email) async {
    try {
      print('$BASE_URL/login/');
      final response = await http.post(
        Uri.parse('$BASE_URL/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
      }
      final Map<String, dynamic> errorData = json.decode(response.body);
      String errorMessage = errorData['detail'];

      if (errorMessage == "No User matches the given query.") {
        errorMessage = "User not found";
      }

      return AuthApiResponse(success: false, errorMessage: errorMessage);
    } catch (e) {
      return AuthApiResponse(success: false, errorMessage: e.toString());
    }
  }

  Future<bool> getUserType(String token, int userId) async {
    try {
      final response = await http.post(
        Uri.parse("$BASE_URL/upload_profile_picture/"),
        headers: {
          'Authorization': 'Token $token',
        },
      );
      final data = json.decode(response.body);
      await storage.write(key: 'user_type', value: data['user_type']);
      return true;
    } catch (e) {
      debugPrint('Error $e');
      return false;
    }
  }

  Future<bool> logout() async {
    String? token = await getToken();

    if (token == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse("$BASE_URL/logout/"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'user_id');
      await storage.delete(key: 'username');
      await storage.delete(key: 'user_type');
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}
