import 'package:quickhire/models/conversation.dart';

class ConversationApiResponse {
  final bool success;
  final Conversation? conversation;

  ConversationApiResponse({required this.success, this.conversation});
}
