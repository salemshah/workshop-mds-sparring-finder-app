import 'package:equatable/equatable.dart';
import '../../models/message/message_model.dart';

/// Base class for all message‐related states.
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

/// Initial state, before any event.
class MessageInitial extends MessageState {
  const MessageInitial();
}

/// Loading (fetching or sending or updating).
class MessageLoadInProgress extends MessageState {
  const MessageLoadInProgress();
}

/// Conversation (list of messages) loaded successfully.
class ConversationLoadSuccess extends MessageState {
  final List<MessageModel> messages;

  const ConversationLoadSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// A new message was successfully sent (and conversation reloaded).
class MessageSentSuccess extends MessageState {
  final List<MessageModel> messages;

  const MessageSentSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// A single message was marked as read successfully.
class MessageReadSuccess extends MessageState {
  final int messageId;

  const MessageReadSuccess(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

/// A message was updated successfully.
class MessageUpdateSuccess extends MessageState {
  final MessageModel updatedMessage;

  const MessageUpdateSuccess(this.updatedMessage);

  @override
  List<Object?> get props => [updatedMessage];
}

/// A message was deleted successfully (for this user).
class MessageDeleteSuccess extends MessageState {
  final int messageId;

  const MessageDeleteSuccess(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

/// Any error in message operations
class MessageFailure extends MessageState {
  final String error;

  const MessageFailure(this.error);

  @override
  List<Object?> get props => [error];
}
