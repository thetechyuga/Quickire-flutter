import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/conversation.dart';
import 'package:quickhire/screens/employer/message/message_screen.dart';
import 'package:quickhire/services/messages/messages_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/message_tile.dart';
import 'package:quickhire/widgets/search_bar.dart';

class ConversationScreen extends StatefulWidget {
  final bool isEmployer;
  const ConversationScreen({super.key, required this.isEmployer});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  MessageApiService messageApiService = MessageApiService();
  late Future<List<Conversation>> _conversationFuture;
  SecureStorageService secureStorageService = SecureStorageService();
  String? username = '';
  String? userId = '';

  fetchInitData() async {
    _conversationFuture = messageApiService.fetchConversations();
    username = await secureStorageService.readUsername();
    userId = await secureStorageService.readUserId();
  }

  updateMessages() {
    _conversationFuture = messageApiService.fetchConversations();
  }

  @override
  void initState() {
    super.initState();
    fetchInitData();
  }

  navigateToMessages(int conversationId, String appBarName) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessageScreen(
                conversationId: conversationId,
                appBarName: appBarName,
              )),
    );

    if (result == true) {
      updateMessages();
    }
  }

  String getAppBarName(String username1, String username2) {
    if (username1.toString() != username.toString()) {
      return username1;
    }
    return username2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchBar(
              hint: 'Search your message',
              svgIconPath: 'assets/icons/search.svg',
              enabled: true,
              controller: TextEditingController(),
              search: (word){},
              focusNode: FocusNode(),
            ),
            const SizedBox(
              height: verticalPadding,
            ),
            FutureBuilder(
              future: _conversationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No user data available.'));
                } else {
                  List<Conversation> conversations = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      String lastSender = conversation
                          .messages[conversation.messages.length - 1]
                          .sender
                          .name;
                      String you = lastSender == username.toString()
                          ? 'You'
                          : lastSender;
                      int userIndex = widget.isEmployer ? 0 : 1;
                      String appBarName = getAppBarName(
                          conversation.participants[0].name,
                          conversation.participants[1].name);

                      return GestureDetector(
                        onTap: () =>
                            navigateToMessages(conversation.id, appBarName),
                        child: MessageTile(
                          senderImg:
                              conversation.participants[userIndex].userPhoto,
                          senderName: conversation.participants[userIndex].name,
                          content:
                              '$you: ${conversation.messages[conversation.messages.length - 1].content}',
                          updatedAt: conversation.updatedAt,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar myCustomAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Messages'),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
    );
  }
}
