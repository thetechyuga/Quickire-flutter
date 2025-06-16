import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/subscription.dart';
import 'package:quickhire/models/subscription_plan.dart';
import 'package:quickhire/utlities.dart';

class SubscriptionApiService {
  final SecureStorageService secureStorageService = SecureStorageService();

  Future<bool> checkSubscriptionStatus() async {
    final String token = await secureStorageService.readToken() ?? "";
    final response = await http.get(
      Uri.parse('$BASE_URL/subscription-status/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['is_active'] ?? false;
    } else {
      throw Exception('Failed to load subscription status');
    }
  }

  Future<Subscription> fetchSubscription() async {
    final String token = await secureStorageService.readToken() ?? "";

    final response = await http.get(
      Uri.parse('$BASE_URL/subscription-status/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['is_active'] == 'false') {
        return Subscription(
            userId: 0,
            startDate: DateTime(1970, 1, 1),
            endDate: DateTime(1970, 1, 1),
            isActive: false);
      }
      return Subscription.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load subscription');
    }
  }

  Future<Subscription> fetchCompanySubscription() async {
    final String token = await secureStorageService.readToken() ?? "";

    final response = await http.get(
      Uri.parse('$BASE_URL/company-subscription-status/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['is_active'] == 'false') {
        return Subscription(
            userId: 0,
            startDate: DateTime(1970, 1, 1),
            endDate: DateTime(1970, 1, 1),
            isActive: false);
      }
      return Subscription.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load subscription');
    }
  }

  Future<bool> createSubscription(Map<String, dynamic> jsonData) async {
    final token = await secureStorageService.readToken();
    final jsonString = jsonEncode(jsonData);
    String url = "$BASE_URL/subscription-status/";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      return true;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw Exception(data['error']);
    }
  }

  Future<bool> createCompanySubscription(Map<String, dynamic> jsonData) async {
    final token = await secureStorageService.readToken();
    final jsonString = jsonEncode(jsonData);
    String url = "$BASE_URL/company-subscription-status/";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      return true;
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw Exception(data['error']);
    }
  }

  Future<List<SubscriptionPlan>> fetchSubscriptionPlans() async {
    final token = await secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/subscription-plans/"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => SubscriptionPlan.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load subscription plans');
    }
  }

  Future<List<SubscriptionPlan>> fetchCompanySubscriptionPlans() async {
    final token = await secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/company-subscription-plans/"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => SubscriptionPlan.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load subscription plans');
    }
  }
}
