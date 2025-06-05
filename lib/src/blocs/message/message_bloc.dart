import 'package:bloc/bloc.dart';
import '../../models/message/message_model.dart';
import '../../repositories/message_repository.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository repository;

  MessageBloc({required this.repository}) : super(const MessageInitial()) {
    on<LoadConversation>(_onLoadConversation);
    on<SendMessage>(_onSendMessage);
    on<MarkMessageRead>(_onMarkMessageRead);
    on<UpdateMessage>(_onUpdateMessage);
    on<DeleteMessage>(_onDeleteMessage);

    // NEW handlers:
    on<ReceiveConversationHistory>(_onReceiveConversationHistory);
    on<ReceiveNewMessage>(_onReceiveNewMessage);
  }

  Future<void> _onLoadConversation(
      LoadConversation event,
      Emitter<MessageState> emit,
      ) async {
    emit(const MessageLoadInProgress());
    try {
      final msgs = await repository.getConversation(
        conversationId: event.conversationId,
        page: event.page,
        limit: event.limit,
      );
      emit(ConversationLoadSuccess(msgs));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event,
      Emitter<MessageState> emit,
      ) async {
    final currentState = state;
    List<MessageModel> currentMessages = [];
    if (currentState is ConversationLoadSuccess) {
      currentMessages = List.from(currentState.messages);
    }
    emit(const MessageLoadInProgress());
    try {
      await repository.createMessage(
        conversationId: event.conversationId,
        content: event.content,
        messageType: event.messageType,
        mediaUrl: event.mediaUrl,
      );
      final updated = await repository.getConversation(
        conversationId: event.conversationId,
        page: 1,
        limit: 50,
      );
      emit(MessageSentSuccess(updated));
    } catch (e) {
      if (currentMessages.isNotEmpty) {
        emit(ConversationLoadSuccess(currentMessages));
      }
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onMarkMessageRead(
      MarkMessageRead event,
      Emitter<MessageState> emit,
      ) async {
    final currentState = state;
    if (currentState is ConversationLoadSuccess) {
      emit(const MessageLoadInProgress());
      try {
        await repository.markMessageRead(
          conversationId: event.conversationId,
          messageId: event.messageId,
        );
        emit(MessageReadSuccess(event.messageId));
      } catch (e) {
        emit(MessageFailure(e.toString()));
      }
    }
  }

  Future<void> _onUpdateMessage(
      UpdateMessage event,
      Emitter<MessageState> emit,
      ) async {
    emit(const MessageLoadInProgress());
    try {
      final updatedMsg = await repository.updateMessage(
        messageId: event.messageId,
        content: event.newContent,
        mediaUrl: event.newMediaUrl,
      );
      emit(MessageUpdateSuccess(updatedMsg));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onDeleteMessage(
      DeleteMessage event,
      Emitter<MessageState> emit,
      ) async {
    final currentState = state;
    if (currentState is ConversationLoadSuccess) {
      emit(const MessageLoadInProgress());
      try {
        await repository.deleteMessage(event.messageId);
        emit(MessageDeleteSuccess(event.messageId));
      } catch (e) {
        emit(MessageFailure(e.toString()));
      }
    }
  }

  // **NEW**: when Socket.IO sends us the initial history
  void _onReceiveConversationHistory(
      ReceiveConversationHistory event,
      Emitter<MessageState> emit,
      ) {
    emit(ConversationLoadSuccess(event.messages));
  }

  // **NEW**: when Socket.IO sends us a single new message
  void _onReceiveNewMessage(
      ReceiveNewMessage event,
      Emitter<MessageState> emit,
      ) {
    final currentState = state;
    if (currentState is ConversationLoadSuccess) {
      final updatedList = List<MessageModel>.from(currentState.messages)
        ..add(event.message);
      emit(ConversationLoadSuccess(updatedList));
    }
  }
}
