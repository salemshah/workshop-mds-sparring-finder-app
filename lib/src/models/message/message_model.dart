// lib/models/message/message_model.dart

class MessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final int? receiverId;      // nullable for group chats
  final String content;
  final String messageType;
  final String? mediaUrl;
  final bool isRead;
  final DateTime sentAt;
  final DateTime? readAt;
  final bool deletedBySender;
  final bool deletedByReceiver;
  final SenderReceiver sender;
  final SenderReceiver? receiver;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.receiverId,
    required this.content,
    required this.messageType,
    this.mediaUrl,
    required this.isRead,
    required this.sentAt,
    this.readAt,
    required this.deletedBySender,
    required this.deletedByReceiver,
    required this.sender,
    this.receiver,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as int,
      senderId: json['sender_id'] as int,
      receiverId: json['receiver_id'] as int?,
      content: json['content'] as String,
      messageType: json['message_type'] as String,
      mediaUrl: json['media_url'] as String?,
      isRead: json['is_read'] as bool,
      sentAt: DateTime.parse(json['sent_at'] as String),
      readAt:
      json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      deletedBySender: json['deleted_by_sender'] as bool,
      deletedByReceiver: json['deleted_by_receiver'] as bool,
      sender: SenderReceiver.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: json['receiver'] != null
          ? SenderReceiver.fromJson(json['receiver'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<MessageModel> listFromJson(List<dynamic> list) {
    return list
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// Nested class for sender/receiver info (with profile)
class SenderReceiver {
  final int id;
  final Profile? profile;

  SenderReceiver({required this.id, this.profile});

  factory SenderReceiver.fromJson(Map<String, dynamic> json) {
    return SenderReceiver(
      id: json['id'] as int,
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Profile with first_name, last_name, photo_url
class Profile {
  final String firstName;
  final String lastName;
  final String photoUrl;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      photoUrl: json['photo_url'] as String,
    );
  }
}
