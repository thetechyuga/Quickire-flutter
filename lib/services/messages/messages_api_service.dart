import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/conversation.dart';
import 'package:quickhire/models/message.dart';
import 'package:quickhire/services/messages/conversation_api_response.dart';
import 'package:quickhire/utlities.dart';

class MessageApiService {
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<List<Conversation>> fetchConversations() async {
    final token = await _secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/conversations/"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Conversation.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load conversations!');
    }
  }

  Future<List<Message>> fetchMessages(conversationId) async {
    final token = await _secureStorageService.readToken();

    final response = await http.get(
      Uri.parse("$BASE_URL/conversations/$conversationId/messages"),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Message.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load messages!');
    }
  }

  Future<ConversationApiResponse> createConversation(
      List<int> participants) async {
    final token = await _secureStorageService.readToken();

    Map<String, dynamic> jsonData = {
      'participants': participants,
    };

    final jsonString = jsonEncode(jsonData);

    final response = await http.post(
      Uri.parse("$BASE_URL/conversations/"),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return ConversationApiResponse(
          success: true, conversation: Conversation.fromJson(jsonResponse));
    } else {
      return ConversationApiResponse(success: false);
    }
  }

  Future<bool> sendMessage(int conversationId, String content) async {
    final token = await _secureStorageService.readToken();

    Map<String, dynamic> jsonData = {
      'content': content,
    };

    final jsonString = jsonEncode(jsonData);

    final response = await http.post(
      Uri.parse("$BASE_URL/conversations/$conversationId/messages/"),
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
}
