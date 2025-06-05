import 'package:sparring_finder/src/repositories/base_repository.dart';
import 'package:sparring_finder/src/models/conversation/conversation_model.dart';

class ConversationRepository extends BaseRepository {
  ConversationRepository({required super.apiService});

  Future<List<ConversationModel>> getConversations() async {
    final response = await apiService.get('/conversations');
    final list = response['conversations'] as List<dynamic>;
    return ConversationModel.listFromJson(list);
  }

  Future<ConversationModel> createConversation({
    required List<int> participantIds,
    String? title,
    String? avatarUrl,
  }) async {
    final payload = {
      'participantIds': participantIds,
      if (title != null) 'title': title,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
    final response = await apiService.post('/conversations', payload);
    final convoJson = response['conversation'] as Map<String, dynamic>;
    return ConversationModel.fromJson(convoJson);
  }

  Future<ConversationModel> getOrCreateOneOnOne(int otherUserId) async {
    final response = await apiService.post(
      '/conversations/one-on-one/$otherUserId',
      {},
    );
    final convoId = (response['conversation'] as Map<String, dynamic>)['id'] as int;
    return ConversationModel(
      id: convoId,
      name: '',
      avatarUrl: '',
      lastMessage: '',
      lastSentAt: DateTime.now(),
      unreadCount: 0,
    );
  }

  Future<void> deleteConversation(int conversationId) async {
    await apiService.delete('/conversations/$conversationId');
  }
}
