import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/education_journey.dart';

class EducationApiService {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<EducationJourney>> fetchEducationJourneys() async {
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'user_id');

    final response = await http.get(
      Uri.parse('$BASE_URL/educationjourneys/users/$userId/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => EducationJourney.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<EducationJourney>> fetchEducationJourneysById(int userId) async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/educationjourneys/users/$userId/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => EducationJourney.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> createEducationJourney(EducationJourney educationJourney) async {
    final token = await storage.read(key: 'token');
    // final userId = await storage.read(key: 'user_id');

    final response = await http.post(
      Uri.parse('$BASE_URL/educationjourneys/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(educationJourney.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateEducationJourney(EducationJourney educationJourney) async {
    final token = await storage.read(key: 'token');
    // final userId = await storage.read(key: 'user_id');

    final response = await http.put(
      Uri.parse(
          '$BASE_URL/educationjourneys/${educationJourney.educationJourneyId}/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(educationJourney.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteEducationJourney(int educationJourneyId) async {
    final token = await storage.read(key: 'token');

    final response = await http.delete(
        Uri.parse('$BASE_URL/educationjourneys/$educationJourneyId/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
