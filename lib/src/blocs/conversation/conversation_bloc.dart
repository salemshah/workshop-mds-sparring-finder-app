import 'package:bloc/bloc.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';
import '../../repositories/conversation_repository.dart';
import '../../models/conversation/conversation_model.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationRepository repository;

  ConversationBloc({required this.repository})
      : super(const ConversationInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<RefreshConversation>(_onRefreshConversation);
    on<CreateConversation>(_onCreateConversation);
    on<StartOrGetOneOnOneConversation>(_onStartOrGetOneOnOneConversation);
    on<DeleteConversation>(_onDeleteConversation);
  }

  Future<void> _onLoadConversations(
      LoadConversations event,
      Emitter<ConversationState> emit,
      ) async {
    emit(const ConversationLoadInProgress());
    try {
      final list = await repository.getConversations();
      list.sort((a, b) => b.lastSentAt.compareTo(a.lastSentAt));
      emit(ConversationLoadSuccess(list));
    } catch (e) {
      emit(ConversationFailure(e.toString()));
    }
  }

  Future<void> _onRefreshConversation(
      RefreshConversation event,
      Emitter<ConversationState> emit,
      ) async {
    final currentState = state;
    if (currentState is ConversationLoadSuccess) {
      final updatedList = <ConversationModel>[];
      for (final convo in currentState.conversations) {
        if (convo.id == event.conversationId) {
          updatedList.add(
            ConversationModel(
              id: convo.id,
              name: convo.name,
              lastMessage: event.lastMessage,
              lastSentAt: event.lastSentAt,
              avatarUrl: convo.avatarUrl,
              unreadCount: convo.unreadCount + 1,
            ),
          );
        } else {
          updatedList.add(convo);
        }
      }
      if (!updatedList.any((c) => c.id == event.conversationId)) {
        updatedList.add(
          ConversationModel(
            id: event.conversationId,
            name: 'Unknown',
            lastMessage: event.lastMessage,
            lastSentAt: event.lastSentAt,
            avatarUrl: '',
            unreadCount: 1,
          ),
        );
      }
      updatedList.sort((a, b) => b.lastSentAt.compareTo(a.lastSentAt));
      emit(ConversationLoadSuccess(updatedList));
    }
  }

  Future<void> _onCreateConversation(
      CreateConversation event,
      Emitter<ConversationState> emit,
      ) async {
    emit(const ConversationCreateInProgress());
    try {
      final newConvo = await repository.createConversation(
        participantIds: event.participantIds,
        title: event.title,
        avatarUrl: event.avatarUrl,
      );
      emit(ConversationCreateSuccess(newConvo));
    } catch (e) {
      emit(ConversationFailure(e.toString()));
    }
  }

  Future<void> _onStartOrGetOneOnOneConversation(
      StartOrGetOneOnOneConversation event,
      Emitter<ConversationState> emit,
      ) async {
    emit(const ConversationCreateInProgress());
    try {
      final convo = await repository.getOrCreateOneOnOne(event.otherUserId);
      emit(ConversationCreateSuccess(convo));
    } catch (e) {
      emit(ConversationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteConversation(
      DeleteConversation event,
      Emitter<ConversationState> emit,
      ) async {
    final currentState = state;
    if (currentState is ConversationLoadSuccess) {
      emit(const ConversationDeleteInProgress());
      try {
        await repository.deleteConversation(event.conversationId);
        final updatedList = currentState.conversations
            .where((c) => c.id != event.conversationId)
            .toList();
        emit(ConversationLoadSuccess(updatedList));
        emit(ConversationDeleteSuccess(event.conversationId));
      } catch (e) {
        emit(ConversationFailure(e.toString()));
      }
    }
  }
}
