class MessageModel {
  final int id;
  final int channelId;
  final int userId;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.channelId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      channelId: json['channel_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      content: json['content'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(), // fallback to now
    );
  }
}
