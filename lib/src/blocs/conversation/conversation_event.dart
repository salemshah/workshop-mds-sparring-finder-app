abstract class ConversationEvent {
  const ConversationEvent();
}

/// Load all conversations for the current user.
class LoadConversations extends ConversationEvent {
  const LoadConversations();
}

/// Refresh a specific conversation’s last message/time/unread count in the list.
class RefreshConversation extends ConversationEvent {
  final int conversationId;
  final String lastMessage;
  final DateTime lastSentAt;

  const RefreshConversation({
    required this.conversationId,
    required this.lastMessage,
    required this.lastSentAt,
  });
}

/// Create a brand-new conversation (group or 1:1) via REST POST `/conversations`.
class CreateConversation extends ConversationEvent {
  final List<int> participantIds;
  final String? title;
  final String? avatarUrl;

  const CreateConversation({
    required this.participantIds,
    this.title,
    this.avatarUrl,
  });
}

/// Get or create a 1-on-1 chat between the current user and [otherUserId].
/// Calls POST `/conversations/one-on-one/:otherUserId`.
class StartOrGetOneOnOneConversation extends ConversationEvent {
  final int otherUserId;
  const StartOrGetOneOnOneConversation({required this.otherUserId});
}

/// Delete an existing conversation by ID via DELETE `/conversations/:conversationId`.
class DeleteConversation extends ConversationEvent {
  final int conversationId;
  const DeleteConversation({required this.conversationId});
}
