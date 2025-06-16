import 'dart:convert';
import 'dart:io';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/company.dart';
import 'package:quickhire/utlities.dart';
import 'package:http/http.dart' as http;

class CompanyApiService {
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Company> fetchCompanyDetails() async {
    final token = await _secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/company-detail/"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Company.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      throw Exception('Company Not found');
    } else {
      throw Exception('Something wrong happened');
    }
  }

  Future<Company> fetchCompanyDetailsById(int companyId) async {
    final token = await _secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/company-detail-by-id/$companyId"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Company.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      throw Exception('Company Not found');
    } else {
      throw Exception('Something wrong happened');
    }
  }

  Future<bool> uploadLogo(File imageFile) async {
    final url = Uri.parse('$BASE_URL/update-company-logo/');
    final token = await _secureStorageService.readToken();

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Token $token';
    request.files
        .add(await http.MultipartFile.fromPath('company_logo', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadBackground(File imageFile) async {
    final url = Uri.parse('$BASE_URL/update-company-banner/');
    final token = await _secureStorageService.readToken();

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Token $token';
    request.files.add(await http.MultipartFile.fromPath(
        'company_background', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> creatCompany(Map<String, dynamic> jsonData) async {
    final token = await _secureStorageService.readToken();
    final jsonString = jsonEncode(jsonData);
    String url = "$BASE_URL/companies/";

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
      return false;
    }
  }

  Future<bool> updateCompany(Map<String, dynamic> jsonData) async {
    final token = await _secureStorageService.readToken();
    final jsonString = jsonEncode(jsonData);
    String url = "$BASE_URL/company-detail/";

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
      return false;
    }
  }
}
