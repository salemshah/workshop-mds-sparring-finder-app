class ConversationModel {
  final int id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastSentAt;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastSentAt,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastSentAt: DateTime.parse(json['lastSentAt'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  static List<ConversationModel> listFromJson(List<dynamic> list) {
    return list
        .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
