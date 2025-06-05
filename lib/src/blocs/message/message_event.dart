import 'package:equatable/equatable.dart';
import '../../models/message/message_model.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

/// Load all messages for a given conversationId (with pagination).
class LoadConversation extends MessageEvent {
  final int conversationId;
  final int page;
  final int limit;

  const LoadConversation({
    required this.conversationId,
    this.page = 1,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [conversationId, page, limit];
}

/// Send a new message in [conversationId] with [content].
class SendMessage extends MessageEvent {
  final int conversationId;
  final String content;
  final String? messageType;
  final String? mediaUrl;

  const SendMessage({
    required this.conversationId,
    required this.content,
    this.messageType,
    this.mediaUrl,
  });

  @override
  List<Object?> get props => [conversationId, content, messageType, mediaUrl];
}

/// Mark a specific [messageId] as read (for this conversation).
class MarkMessageRead extends MessageEvent {
  final int conversationId;
  final int messageId;

  const MarkMessageRead({
    required this.conversationId,
    required this.messageId,
  });

  @override
  List<Object?> get props => [conversationId, messageId];
}

/// (Optional) Update an existing message
class UpdateMessage extends MessageEvent {
  final int messageId;
  final String newContent;
  final String? newMediaUrl;

  const UpdateMessage({
    required this.messageId,
    required this.newContent,
    this.newMediaUrl,
  });

  @override
  List<Object?> get props => [messageId, newContent, newMediaUrl];
}

/// (Optional) Delete a message for the current user
class DeleteMessage extends MessageEvent {
  final int messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

/// **NEW**: Receive the initial batch of messages from Socket.IO
class ReceiveConversationHistory extends MessageEvent {
  final List<MessageModel> messages;

  const ReceiveConversationHistory(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// **NEW**: Receive a single new message from Socket.IO
class ReceiveNewMessage extends MessageEvent {
  final MessageModel message;

  const ReceiveNewMessage(this.message);

  @override
  List<Object?> get props => [message];
}
