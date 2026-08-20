import 'package:meathub/models/chat_message_model.dart';

enum TicketStatus { open, resolved }

class TicketModel {
  final String id;
  final String title;
  final String? orderId;
  final DateTime createdAt;
  DateTime lastReplyAt;
  TicketStatus status;
  final List<ChatMessageModel> messages;

  TicketModel({
    required this.id,
    required this.title,
    this.orderId,
    required this.createdAt,
    required this.lastReplyAt,
    this.status = TicketStatus.open,
    List<ChatMessageModel>? messages,
  }) : messages = messages ?? [];
}