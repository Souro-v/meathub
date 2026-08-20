import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meathub/data/dummy_tickets.dart';
import 'package:meathub/models/chat_message_model.dart';
import 'package:meathub/models/ticket_model.dart';

class TicketProvider extends ChangeNotifier {
  final List<TicketModel> _tickets = [];

  TicketProvider() {
    _tickets.addAll(DummyTickets.seed());
  }

  List<TicketModel> get tickets {
    final sorted = List<TicketModel>.of(_tickets);
    sorted.sort((a, b) => b.lastReplyAt.compareTo(a.lastReplyAt));
    return sorted;
  }

  List<TicketModel> get openTickets =>
      tickets.where((t) => t.status == TicketStatus.open).toList();

  List<TicketModel> get resolvedTickets =>
      tickets.where((t) => t.status == TicketStatus.resolved).toList();

  TicketModel? findById(String id) {
    try {
      return _tickets.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  TicketModel createTicket({
    required String title,
    String? orderId,
    required String initialMessage,
    String? imagePath,
  }) {
    final id = '#MH${100000 + Random().nextInt(89999)}';
    final now = DateTime.now();
    final ticket = TicketModel(
      id: id,
      title: title,
      orderId: orderId,
      createdAt: now,
      lastReplyAt: now,
    );
    ticket.messages.add(
      ChatMessageModel(
        text: initialMessage,
        imagePath: imagePath,
        isMe: true,
        timestamp: now,
      ),
    );
    ticket.messages.add(
      ChatMessageModel(
        text:
            "Thanks for reaching out! We've received your report and our team will get back to you shortly.",
        isMe: false,
        timestamp: now.add(const Duration(minutes: 1)),
      ),
    );
    ticket.lastReplyAt = now.add(const Duration(minutes: 1));
    _tickets.insert(0, ticket);
    notifyListeners();
    return ticket;
  }

  void addMessage(String ticketId, ChatMessageModel message) {
    final ticket = findById(ticketId);
    if (ticket == null) return;
    ticket.messages.add(message);
    ticket.lastReplyAt = message.timestamp;
    notifyListeners();

    if (message.isMe) {
      Future.delayed(const Duration(seconds: 1), () {
        ticket.messages.add(
          ChatMessageModel(
            text: "Got it! We're looking into this and will update you soon.",
            isMe: false,
            timestamp: DateTime.now(),
          ),
        );
        ticket.lastReplyAt = DateTime.now();
        notifyListeners();
      });
    }
  }
}
