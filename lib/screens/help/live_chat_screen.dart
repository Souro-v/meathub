import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/chat_bubble.dart';
import 'package:meathub/core/widgets/chat_input_bar.dart';
import 'package:meathub/models/chat_message_model.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      text: 'Hello! 👋\nHow can we help you today?',
      isMe: false,
      timestamp: DateTime.now(),
    ),
  ];

  void _sendText(String text) {
    setState(
      () => _messages.add(
        ChatMessageModel(text: text, isMe: true, timestamp: DateTime.now()),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(
        () => _messages.add(
          ChatMessageModel(
            text:
                'Thanks! Please share your Order ID and a photo if possible, so we can look into this quickly.',
            isMe: false,
            timestamp: DateTime.now(),
          ),
        ),
      );
    });
  }

  void _sendImage(File file) {
    setState(
      () => _messages.add(
        ChatMessageModel(
          imagePath: file.path,
          isMe: true,
          timestamp: DateTime.now(),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(
        () => _messages.add(
          ChatMessageModel(
            text: 'Thank you! We are checking this for you.',
            isMe: false,
            timestamp: DateTime.now(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) =>
                    ChatBubble(message: _messages[index]),
              ),
            ),
            ChatInputBar(onSend: _sendText, onSendImage: _sendImage),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.meatHubSupportTitle,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.circle, size: 7, color: AppColors.success),
                  SizedBox(width: 4),
                  Text(
                    AppStrings.onlineLabel,
                    style: TextStyle(fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
