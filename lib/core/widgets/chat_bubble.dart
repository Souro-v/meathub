import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/models/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            padding: message.imagePath != null
                ? const EdgeInsets.all(6)
                : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: Radius.circular(isMe ? 14 : 3),
                bottomRight: Radius.circular(isMe ? 3 : 14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(message.imagePath!),
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (message.text != null && message.text!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                      top: message.imagePath != null ? 6 : 0,
                    ),
                    child: Text(
                      message.text!,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isMe ? AppColors.white : AppColors.textDark,
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 10),
            child: Text(
              OrderUtils.formatTime(message.timestamp),
              style: const TextStyle(fontSize: 10, color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}
