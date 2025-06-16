import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/user_details.dart';
import 'package:quickhire/services/user/user_api_response.dart';
import 'package:quickhire/utlities.dart';

class UserApiService {
  final storage = const FlutterSecureStorage();
  final SecureStorageService secureStorageService = SecureStorageService();

  Future<UserDetails> fetchUser() async {
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'user_id');
    final response = await http.get(
      Uri.parse('$BASE_URL/users/$userId/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return UserDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<UserDetails> fetchUserById(int userId) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$BASE_URL/users/$userId/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return UserDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<UserApiResponse> updateUser(Map<String, dynamic> data) async {
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'user_id');

    final response = await http.put(
      Uri.parse('$BASE_URL/users/$userId/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return UserApiResponse(
          success: true,
          userDetails: UserDetails.fromJson(json.decode(response.body)));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<UserApiResponse> patchUser(Map<String, dynamic> data) async {
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'user_id');

    final response = await http.patch(
      Uri.parse('$BASE_URL/users/$userId/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return UserApiResponse(
          success: true,
          userDetails: UserDetails.fromJson(json.decode(response.body)));
    } else {
      throw Exception('Failed to patch user');
    }
  }

  Future<bool> isNetworkConnected() async {

    final response = await http.get(
      Uri.parse('$BASE_URL/test_token/'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 403) {
      return true;
    } else {
      return false;
    }
  }
  // API to handle image

  Future<bool> uploadImage(File imageFile) async {
    final url = Uri.parse('$BASE_URL/upload_profile_picture/');
    final token = await secureStorageService.readToken();

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Token $token';
    request.files
        .add(await http.MultipartFile.fromPath('user_photo', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
