import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/utlities.dart';

class MessageTile extends StatelessWidget {
  final String senderImg;
  final String senderName;
  final String content;
  final String updatedAt;

  const MessageTile({
    super.key,
    required this.senderImg,
    required this.senderName,
    required this.content,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding + 8,
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(BASE_URL+senderImg)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        senderName,
                        style: const TextStyle(
                          color: primaryText,
                          fontWeight: poppinsRegular,
                          fontSize: largeFontSize,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formatDate(updatedAt),
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: smallFontSize,
                          fontWeight: poppinsRegular,
                        ),
                      )
                    ],
                  ),
                  Text(
                    content.length < 100
                        ? content
                        : '${content.substring(0, 100)}...',
                    style: const TextStyle(
                      fontSize: smallFontSize,
                      fontWeight: poppinsRegular,
                      color: secondaryText,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
