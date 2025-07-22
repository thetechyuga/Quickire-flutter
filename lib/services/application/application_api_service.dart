// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/application.dart';
import 'package:quickhire/services/application/chart_data_reponse.dart';
import 'package:quickhire/utlities.dart';

class ApplicationApiService {
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<List<Application>> fetchApplications() async {
    final token = await _secureStorageService.readToken();
    final userId = await _secureStorageService.readUserId();

    final response = await http.get(
      Uri.parse("$BASE_URL/applications/users/$userId"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Application.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load applications/');
    }
  }

  Future<List<Application>> fetchApplicationsBySatus(String status) async {
    final token = await _secureStorageService.readToken();
    final userId = await _secureStorageService.readUserId();

    final response = await http.get(
      Uri.parse("$BASE_URL/applications/users/$userId/status/$status"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Application.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load applications/');
    }
  }

  Future<bool> applyForJob(int jobId) async {
    final token = await _secureStorageService.readToken() ?? "";
    final user = await _secureStorageService.readUserId() ?? "";
    final userId = int.parse(user);
    const status = "Applied";
    final response = await http.post(
      Uri.parse('$BASE_URL/applications/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId,
        'job_id': jobId,
        'status': status,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // api for applications by job id & status
  Future<List<Application>> fetchApplicationsByJobId(
      int jobId, String? status) async {
    final token = await _secureStorageService.readToken();

    String url = status == null
        ? "$BASE_URL/applications/jobs/$jobId"
        : "$BASE_URL/applications/jobs/$jobId/?status=$status";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Application.fromJson(data)).toList();
    } else if (response.statusCode == 404) {
      final data = json.decode(response.body);
      throw Exception(data['detail']);
    } else {
      throw Exception("Not able to load jobs");
    }
  }

  // Function to fetch and parse the data
  Future<ChartDataResponse> fetchApplicationData() async {
    final token = await _secureStorageService.readToken();
    print(token);
    print('$BASE_URL/applications/last7days/');
    final response = await http.get(
      Uri.parse('$BASE_URL/applications/last7days/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(data);
      // Lists to store dates and application counts
      List<String> dates = [];
      List<int> applicationCounts = [];

      // Iterate through the data and extract date and count
      for (var item in data) {
        dates.add(item['date']); // Add date to the dates list
        applicationCounts.add(item[
            'applications_count']); // Add count to the applicationCounts list
      }

      return ChartDataResponse(
          applicationCounts: applicationCounts, dates: dates);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
