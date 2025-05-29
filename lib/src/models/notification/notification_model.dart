import 'package:equatable/equatable.dart';
import '../profile/profile_model.dart';

/// Core domain model for a notification, including sender's profile.
class NotificationModel extends Equatable {
  final int id;
  final int userId;
  final int senderId;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final String via;
  final DateTime sentAt;
  final DateTime? readAt;
  final String? actionUrl;
  final Profile sender;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.senderId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.via,
    required this.sentAt,
    this.readAt,
    this.actionUrl,
    required this.sender,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      senderId: json['sender_id'],
      type: json['type'],
      title: json['title'],
      body: json['body'],
      isRead: json['is_read'],
      via: json['via'],
      sentAt: DateTime.parse(json['sent_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      actionUrl: json['action_url'],
      sender: Profile.fromJson(json['senderProfile']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'sender_id': senderId,
    'type': type,
    'title': title,
    'body': body,
    'is_read': isRead,
    'via': via,
    'sent_at': sentAt.toIso8601String(),
    'read_at': readAt?.toIso8601String(),
    'action_url': actionUrl,
    'senderProfile': sender.toJson(),
  };

  static List<NotificationModel> listFromJson(List<dynamic> data) =>
      data.map((e) => NotificationModel.fromJson(e)).toList();

  @override
  List<Object?> get props => [
    id,
    userId,
    senderId,
    type,
    title,
    body,
    isRead,
    via,
    sentAt,
    readAt,
    actionUrl,
    sender,
  ];
}
