import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as s_io;
import 'package:sparring_finder/generated/assets.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import '../../../config/app_constants.dart';
import '../../../blocs/message/message_bloc.dart';
import '../../../blocs/message/message_event.dart';
import '../../../blocs/message/message_state.dart';
import '../../../models/message/message_model.dart';
import '../../../repositories/message_repository.dart';
import '../../../utils/jwt.dart';
import '../../skeletons/chat_screen_skeleton.dart';
import '../../theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final int conversationId;
  final String conversationName;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.conversationName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final MessageBloc _messageBloc;
  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  s_io.Socket? _socket;

  bool _socketReady = false;
  bool _isTyping = false;
  Timer? _typingTimer;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();

    _initializeBlocAndData();
    _getCurrentUserId();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    if (_socket != null) {
      _socket!
        ..off('connect')
        ..off('join_conversation_ack')
        ..off('disconnect')
        ..off('connect_error')
        ..off('conversation_history')
        ..off('new_message')
        ..off('typing')
        ..off('error');
      _socket!.disconnect();
      _socket!.dispose();
    }

    _textController.dispose();
    _scrollController.dispose();
    _messageBloc.close();
    super.dispose();
  }

  void _initializeBlocAndData() {
    final messageRepo = context.read<MessageRepository>();
    _messageBloc = MessageBloc(repository: messageRepo);

    // Load initial history via REST
    _messageBloc.add(
      LoadConversation(
        conversationId: widget.conversationId,
        page: 1,
        limit: 50,
      ),
    );

    // Connect socket afterwards
    _connectSocket();
  }

  Future<void> _getCurrentUserId() async {
    final userInfo = await JwtStorageHelper.getDecodedAccessToken();
    if (!mounted) return;
    setState(() {
      _currentUserId = userInfo["id"] as int;
    });
  }

  Future<void> _connectSocket() async {
    final token = await JwtStorageHelper.getAccessToken();
    if (token == null) {
      debugPrint('No JWT token; cannot connect socket.');
      return;
    }

    final socketUrl = AppConstants.socketBaseUrl;
    debugPrint('Attempting WebSocket connect to $socketUrl');

    _socket = s_io.io(
      socketUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'path': '/socket.io',
        'auth': {'token': token},
      },
    );

    // On successful connection, join the room
    _socket!.on('connect', (_) {
      debugPrint('Socket.s_io connected (id=${_socket!.id})');
      _socket!.emit('join_conversation', {
        'conversationId': widget.conversationId,
      });
      debugPrint(
          'Emitted join_conversation → conversation_${widget.conversationId}');
    });

    // Wait for server ack that we’re in the room
    _socket!.on('join_conversation_ack', (data) {
      debugPrint('Received join_conversation_ack: $data');
      if (!mounted) return;
      setState(() => _socketReady = true);
    });

    _socket!.on('connect_error', (err) {
      debugPrint(' Socket connect_error: $err');
    });

    _socket!.on('disconnect', (_) {
      debugPrint('Socket.s_io disconnected');
      if (!mounted) return;
      setState(() => _socketReady = false);
    });

    // Listen for conversation history from socket
    _socket!.on('conversation_history', (data) {
      if (data is Map<String, dynamic> && data['messages'] is List) {
        final rawList = data['messages'] as List<dynamic>;
        final msgs = rawList
            .whereType<Map<String, dynamic>>()
            .map(MessageModel.fromJson)
            .toList();

        _messageBloc.add(ReceiveConversationHistory(msgs));
      }
    });

    // Listen for new incoming messages
    _socket!.on('new_message', (data) {
      if (data is Map<String, dynamic> &&
          data['message'] is Map<String, dynamic>) {
        final newMsg = MessageModel.fromJson(
          data['message'] as Map<String, dynamic>,
        );
        _messageBloc.add(ReceiveNewMessage(newMsg));
      }
    });

    // Listen for typing notifications
    _socket!.on('typing', (data) {
      if (data is Map<String, dynamic> && data.containsKey('isTyping')) {
        final isTyping = data['isTyping'] as bool;
        if (!mounted) return;
        setState(() => _isTyping = isTyping);
      }
    });

    _socket!.on('error', (errData) {
      debugPrint('Socket error: $errData');
    });
  }


  void _onTextChanged(String text) {
    if (_socket == null || !_socketReady) return;

    // Emit “typing = true” immediately when user starts typing
    if (_typingTimer?.isActive != true) {
      _socket!.emit('typing', {
        'conversationId': widget.conversationId,
        'isTyping': true,
      });
    }

    // Reset the existing timer
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 800), () {
      // After 800ms of no keystroke, emit “typing = false”
      _socket!.emit('typing', {
        'conversationId': widget.conversationId,
        'isTyping': false,
      });
    });
  }

  void _onSendPressed() {
    final text = _textController.text.trim();
    if (text.isEmpty || !_socketReady) return;

    // Emit the message via socket
    _socket!.emit('send_message', {
      'conversationId': widget.conversationId,
      'content': text,
    });

    // Clear the input immediately
    _textController.clear();

    // Send “typing = false” if user was typing
    _typingTimer?.cancel();
    _socket!.emit('typing', {
      'conversationId': widget.conversationId,
      'isTyping': false,
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>.value(
      value: _messageBloc,
      child: Scaffold(
        backgroundColor: AppColors.inputFill,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          titleTextStyle: TextStyle(
              color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 22),
          title: Text(widget.conversationName.capitalizeEachWord()),
          backgroundColor: AppColors.background,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      3, // Number of icons per row (tweak as needed)
                ),
                itemBuilder: (context, index) {
                  return Center(
                    child: Opacity(
                      opacity: 0.15,
                      child: Image.asset(
                        Assets.iconsMmaBackgroundIcon,
                        width: 220,
                        height: 220,
                        color: Colors.green,
                        colorBlendMode: BlendMode.srcIn,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: BlocListener<MessageBloc, MessageState>(
                    listener: (context, state) {
                      // Whenever history or a new message arrives, scroll down:
                      if (state is ConversationLoadSuccess ||
                          state is MessageLoadInProgress) {
                        _scrollToBottom();
                      }
                    },
                    child: BlocBuilder<MessageBloc, MessageState>(
                      builder: (context, state) {
                        if (state is MessageLoadInProgress) {
                          return const ChatScreenSkeleton();
                        }
                        if (state is ConversationLoadSuccess) {
                          final messages = state.messages;
                          if (messages.isEmpty) {
                            return const Center(
                              child: Text(
                                'No messages yet. Say hello!',
                                style: TextStyle(color: AppColors.text),
                              ),
                            );
                          }
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final reverseIndex = messages.length - 1 - index;
                              final msg = messages[reverseIndex];
                              final isMe =
                                  msg.senderId == (_currentUserId ?? -1);
                              return _MessageBubble(
                                message: msg,
                                isMe: isMe,
                              );
                            },
                          );
                        }

                        if (state is MessageFailure) {
                          return Center(
                            child: Text(
                              'Error: ${state.error}',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        // Default to empty container
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                // Typing indicator (single widget at bottom, above input)
                if (_isTyping)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Typing...',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),

                // Input field + Send button
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  color: AppColors.background,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white),
                          onChanged: _onTextChanged,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: AppColors.text),
                            filled: true,
                            fillColor: AppColors.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide:
                                  const BorderSide(color: Color(0xFF2A2A2A)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _onSendPressed,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    color: AppColors.background,
                    height: MediaQuery.of(context).padding.bottom)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Extracted widget for a single message bubble (cleaner)
class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const _MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? AppColors.primary : AppColors.background;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final margin = isMe
        ? const EdgeInsets.only(left: 64, right: 16, top: 4, bottom: 4)
        : const EdgeInsets.only(right: 64, left: 16, top: 4, bottom: 4);

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: margin,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(isMe ? 12 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 12),
            ),
          ),
          child: Text(
            message.content,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: isMe ? 0 : 16,
            right: isMe ? 16 : 0,
            bottom: 8,
          ),
          child: Text(
            _formatTime(message.sentAt),
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final hour = local.hour > 12
        ? local.hour - 12
        : local.hour == 0
            ? 12
            : local.hour;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
