import 'package:sparring_finder/src/repositories/base_repository.dart';
import 'package:sparring_finder/src/models/message/message_model.dart';

class MessageRepository extends BaseRepository {
  MessageRepository({required super.apiService});

  // -------------------------------------------------------------------------
  // GET `/messages/conversation/:conversationId?page=&limit=`
  // -------------------------------------------------------------------------
  Future<List<MessageModel>> getConversation({
    required int conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    final response = await apiService.get(
      '/messages/conversation/$conversationId?page=$page&limit=$limit',
    );
    final list = response['messages'] as List<dynamic>;
    return MessageModel.listFromJson(list);
  }

  // -------------------------------------------------------------------------
  // GET `/messages/:messageId` — fetch single message
  // -------------------------------------------------------------------------
  Future<MessageModel?> getMessageById(int messageId) async {
    final response = await apiService.get('/messages/$messageId');
    final msgJson = response['message'] as Map<String, dynamic>?;
    return msgJson != null ? MessageModel.fromJson(msgJson) : null;
  }

  // -------------------------------------------------------------------------
  // POST `/messages` — create a new message
  // Body: { conversationId, content, messageType?, mediaUrl? }
  // -------------------------------------------------------------------------
  Future<MessageModel> createMessage({
    required int conversationId,
    required String content,
    String? messageType,
    String? mediaUrl,
  }) async {
    final payload = <String, dynamic>{
      'conversationId': conversationId,
      'content': content,
      if (messageType != null) 'messageType': messageType,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
    };
    final response = await apiService.post('/messages', payload);
    final msgJson = response['message'] as Map<String, dynamic>;
    return MessageModel.fromJson(msgJson);
  }

  // -------------------------------------------------------------------------
  // PUT `/messages/:messageId` — update existing message
  // Body: { content?, messageType?, mediaUrl? }
  // -------------------------------------------------------------------------
  Future<MessageModel> updateMessage({
    required int messageId,
    String? content,
    String? messageType,
    String? mediaUrl,
  }) async {
    final payload = <String, dynamic>{};
    if (content != null) payload['content'] = content;
    if (messageType != null) payload['messageType'] = messageType;
    if (mediaUrl != null) payload['mediaUrl'] = mediaUrl;

    final response =
    await apiService.put('/messages/$messageId', payload);
    final msgJson = response['message'] as Map<String, dynamic>;
    return MessageModel.fromJson(msgJson);
  }

  // -------------------------------------------------------------------------
  // PUT `/messages/:messageId/read` — mark a message as read
  // -------------------------------------------------------------------------
  Future<void> markMessageRead({
    required int conversationId,
    required int messageId,
  }) async {
    // We ignore conversationId here, as the backend route is /messages/:messageId/read
    await apiService.put('/messages/$messageId/read', {});
  }

  // -------------------------------------------------------------------------
  // DELETE `/messages/:messageId` — soft‐delete a message for the user
  // -------------------------------------------------------------------------
  Future<void> deleteMessage(int messageId) async {
    await apiService.delete('/messages/$messageId');
  }
}
