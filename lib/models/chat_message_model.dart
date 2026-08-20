class ChatMessageModel {
  final String? text;
  final String? imagePath;
  final bool isMe;
  final DateTime timestamp;

  const ChatMessageModel({
    this.text,
    this.imagePath,
    required this.isMe,
    required this.timestamp,
  });
}
