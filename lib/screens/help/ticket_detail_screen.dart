import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/chat_bubble.dart';
import 'package:meathub/core/widgets/chat_input_bar.dart';
import 'package:meathub/models/chat_message_model.dart';
import 'package:meathub/models/ticket_model.dart';
import 'package:meathub/providers/ticket_provider.dart';

class TicketDetailScreen extends StatelessWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    final ticket = context.watch<TicketProvider>().findById(ticketId);

    if (ticket == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: Center(child: Text(AppStrings.ticketNotFound))),
      );
    }

    final isOpen = ticket.status == TicketStatus.open;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, ticket, isOpen),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (ticket.orderId != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${AppStrings.orderIdLabel}: ${ticket.orderId}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: ticket.messages.length,
                itemBuilder: (context, index) =>
                    ChatBubble(message: ticket.messages[index]),
              ),
            ),
            if (isOpen)
              ChatInputBar(
                onSend: (text) => context.read<TicketProvider>().addMessage(
                  ticketId,
                  ChatMessageModel(
                    text: text,
                    isMe: true,
                    timestamp: DateTime.now(),
                  ),
                ),
                onSendImage: (file) =>
                    context.read<TicketProvider>().addMessage(
                      ticketId,
                      ChatMessageModel(
                        imagePath: file.path,
                        isMe: true,
                        timestamp: DateTime.now(),
                      ),
                    ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: AppColors.successSoft,
                  border: Border(top: BorderSide(color: AppColors.divider)),
                ),
                child: const Text(
                  AppStrings.ticketResolvedNote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, TicketModel ticket, bool isOpen) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOpen
                              ? AppColors.success
                              : AppColors.textHint,
                        ),
                      ),
                      Text(
                        isOpen
                            ? AppStrings.openLabel
                            : AppStrings.resolvedLabel,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isOpen
                              ? AppColors.success
                              : AppColors.textHint,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    AppStrings.ticketDetailsTitle,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${AppStrings.ticketIdLabel}: ${ticket.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
