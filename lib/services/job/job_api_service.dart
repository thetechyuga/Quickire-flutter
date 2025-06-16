// api_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/utlities.dart';

class JobApiService {
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<List<Job>> fetchJobs() async {
    final token = await _secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/available-jobs/"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Job.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<Job> fetchSingleJob(String number) async {
    final token = await _secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/jobs/$number"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Job.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<List<Job>> searchJob(String query) async {
    final token = await _secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/search-jobs?query=$query"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Job.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

// employer code

  Future<List<Job>> fetchEmployerJobs(bool? status) async {
    final token = await _secureStorageService.readToken();
    String url = status == null
        ? "$BASE_URL/get-employer-jobs/"
        : "$BASE_URL/get-employer-jobs/?is_active=$status";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Job.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<Map<String, dynamic>> fetchEmployerJobsStatus() async {
    final token = await _secureStorageService.readToken();

    String url = "$BASE_URL/job-status-count/";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get the data!');
    }
  }

  Future<bool> createJob(Map<String, dynamic> jsonData) async {
    final token = await _secureStorageService.readToken();
    final jsonString = jsonEncode(jsonData);
    String url = "$BASE_URL/jobs/";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw Exception(data['error']);
    }
  }

  Future<bool> updateJob(Map<String, dynamic> jsonData, int jobId) async {
    final token = await _secureStorageService.readToken();
    final jsonString = jsonEncode(jsonData);
    String url = "$BASE_URL/jobs/$jobId/";

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint(response.body);
      return false;
    }
  }

  Future<bool> deleteJob(int jobId) async {
    final token = await _secureStorageService.readToken();
    String url = "$BASE_URL/jobs/$jobId/";

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      debugPrint(response.body);
      return false;
    }
  }
}
