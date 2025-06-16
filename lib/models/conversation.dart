import 'package:quickhire/models/user_details.dart';
import 'message.dart';

class Conversation {
  final int id;
  final List<UserDetails> participants;
  final List<Message> messages;
  final String createdAt;
  final String updatedAt;

  Conversation({
    required this.id,
    required this.participants,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var participantsJson = json['participants'] as List;
    List<UserDetails> participantsList =
        participantsJson.map((i) => UserDetails.fromJson(i)).toList();

    var messagesJson = json['messages'] as List;
    List<Message> messagesList =
        messagesJson.map((i) => Message.fromJson(i)).toList();

    return Conversation(
      id: json['id'],
      participants: participantsList,
      messages: messagesList,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants
          .map((userParticipant) => userParticipant.toJson())
          .toList(),
      'messages': messages.map((message) => message.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
