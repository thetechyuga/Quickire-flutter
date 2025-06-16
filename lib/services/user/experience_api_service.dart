import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/experience_journey.dart';

class ExperienceApiService {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<ExperienceJourney>> fetchExperienceJourneys() async {
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'user_id');

    final response = await http.get(
      Uri.parse('$BASE_URL/experiencejourneys/users/$userId/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => ExperienceJourney.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<ExperienceJourney>> fetchExperienceJourneysById(
      int userId) async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/experiencejourneys/users/$userId/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => ExperienceJourney.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> createExperienceJourney(
      ExperienceJourney experienceJourney) async {
    final token = await storage.read(key: 'token');
    // final userId = await storage.read(key: 'user_id');

    final response = await http.post(
      Uri.parse('$BASE_URL/experiencejourneys/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(experienceJourney.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateExperienceJourney(
      ExperienceJourney experienceJourney) async {
    final token = await storage.read(key: 'token');
    // final userId = await storage.read(key: 'user_id');

    final response = await http.put(
      Uri.parse(
          '$BASE_URL/experiencejourneys/${experienceJourney.experienceJourneyId}/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(experienceJourney.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteExperienceJourney(int experienceJourneyId) async {
    final token = await storage.read(key: 'token');

    final response = await http.delete(
        Uri.parse('$BASE_URL/experiencejourneys/$experienceJourneyId/'),
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
