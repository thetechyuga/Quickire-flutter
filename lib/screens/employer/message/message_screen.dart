import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/message.dart';
import 'package:quickhire/services/messages/messages_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_app_bar.dart';

class MessageScreen extends StatefulWidget {
  final String appBarName;
  final int conversationId;
  const MessageScreen(
      {super.key, required this.conversationId, required this.appBarName});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  SecureStorageService storageService = SecureStorageService();
  String userId = '';
  MessageApiService messageApiService = MessageApiService();
  TextEditingController messageTextController = TextEditingController();
  late Future<List<Message>> _messageFuture;

  fetchInitData() async {
    _messageFuture = messageApiService.fetchMessages(widget.conversationId);
    userId = await storageService.readUserId() ?? '';
  }

  @override
  void initState() {
    super.initState();
    fetchInitData();
  }

  sendMessage(int conversationId) async {
    bool response = await messageApiService.sendMessage(
        conversationId, messageTextController.text);
    if (response) {
      setState(() {
        fetchInitData();
        messageTextController.text = '';
      });

      return;
    }
    showErrorDialog(
        'Message not sent!',
        "We're sorry for the inconvience but message was not sent. Kindly try again",
        context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(widget.appBarName),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _messageFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No user data available.'));
                  } else {
                    List<Message> messages = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.sender.userId.toString() == userId;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: messagePill(isMe, message),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 8,
                right: 2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 5,
                      controller: messageTextController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        hintText: 'Enter your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryColor, // Background color
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(
                            50), // Adjust the border radius as needed
                      ),
                      child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.send,
                            color: whiteText,
                          )),
                    ),
                    onPressed: () => {sendMessage(widget.conversationId)},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messagePill(bool isMe, Message message) {
    return Column(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isMe ? primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message.content,
            style: TextStyle(color: isMe ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
