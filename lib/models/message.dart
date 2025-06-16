import 'package:quickhire/models/user_details.dart';

class Message {
  final int id;
  final UserDetails sender;
  final String content;
  final DateTime timestamp;
  final int conversation;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.conversation,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: UserDetails.fromJson(json['sender']),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      conversation: json['conversation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'conversation': conversation,
    };
  }
}
