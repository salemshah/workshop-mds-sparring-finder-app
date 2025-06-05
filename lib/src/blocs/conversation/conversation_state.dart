import '../../models/conversation/conversation_model.dart';

abstract class ConversationState {
  const ConversationState();
}

/// Initial (idle) state.
class ConversationInitial extends ConversationState {
  const ConversationInitial();
}

/// Emitted when all conversations are being loaded.
class ConversationLoadInProgress extends ConversationState {
  const ConversationLoadInProgress();
}

/// Emitted when conversations have successfully loaded.
class ConversationLoadSuccess extends ConversationState {
  final List<ConversationModel> conversations;
  const ConversationLoadSuccess(this.conversations);
}

/// Emitted when there is an error loading or mutating conversations.
class ConversationFailure extends ConversationState {
  final String error;
  const ConversationFailure(this.error);
}

/// Emitted when a create or “get-or-create” call is in progress.
class ConversationCreateInProgress extends ConversationState {
  const ConversationCreateInProgress();
}

/// Emitted when a new conversation (or existing 1-on-1) is returned.
class ConversationCreateSuccess extends ConversationState {
  final ConversationModel newConversation;
  const ConversationCreateSuccess(this.newConversation);
}

/// Emitted when a delete request is in progress.
class ConversationDeleteInProgress extends ConversationState {
  const ConversationDeleteInProgress();
}

/// Emitted when a conversation has been deleted successfully.
class ConversationDeleteSuccess extends ConversationState {
  final int deletedConversationId;
  const ConversationDeleteSuccess(this.deletedConversationId);
}
