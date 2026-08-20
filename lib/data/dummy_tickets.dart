import 'package:meathub/models/chat_message_model.dart';
import 'package:meathub/models/ticket_model.dart';

class DummyTickets {
  DummyTickets._();

  static List<TicketModel> seed() {
    final now = DateTime.now();
    return [
      TicketModel(
        id: '#MH12567',
        title: 'Wrong item received',
        orderId: '#ORD12345',
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        lastReplyAt: now.subtract(
          const Duration(days: 2, hours: 2, minutes: 45),
        ),
        status: TicketStatus.open,
        messages: [
          ChatMessageModel(
            text:
                'I received a different item from what I ordered. I ordered Beef Curry Cut, but received Beef Mince.',
            isMe: true,
            timestamp: now.subtract(const Duration(days: 2, hours: 3)),
          ),
          ChatMessageModel(
            text:
                "We're sorry for the inconvenience. We will arrange a replacement for you.",
            isMe: false,
            timestamp: now.subtract(
              const Duration(days: 2, hours: 2, minutes: 45),
            ),
          ),
        ],
      ),
      TicketModel(
        id: '#MH12498',
        title: 'Refund not received',
        orderId: '#ORD12310',
        createdAt: now.subtract(const Duration(days: 4, hours: 5)),
        lastReplyAt: now.subtract(
          const Duration(days: 4, hours: 4, minutes: 35),
        ),
        status: TicketStatus.open,
        messages: [
          ChatMessageModel(
            text:
                'I cancelled my order 5 days ago but still have not received my refund.',
            isMe: true,
            timestamp: now.subtract(const Duration(days: 4, hours: 5)),
          ),
          ChatMessageModel(
            text:
                "We're checking with our payments team and will update you within 24 hours.",
            isMe: false,
            timestamp: now.subtract(
              const Duration(days: 4, hours: 4, minutes: 35),
            ),
          ),
        ],
      ),
      TicketModel(
        id: '#MH12345',
        title: 'Damaged item',
        orderId: '#ORD12222',
        createdAt: now.subtract(const Duration(days: 8, hours: 6)),
        lastReplyAt: now.subtract(const Duration(days: 7, hours: 23)),
        status: TicketStatus.resolved,
        messages: [
          ChatMessageModel(
            text: 'The packaging was torn and the meat looked spoiled.',
            isMe: true,
            timestamp: now.subtract(const Duration(days: 8, hours: 6)),
          ),
          ChatMessageModel(
            text:
                "We've issued a full refund for this order. Sorry for the trouble!",
            isMe: false,
            timestamp: now.subtract(const Duration(days: 7, hours: 23)),
          ),
        ],
      ),
    ];
  }
}
