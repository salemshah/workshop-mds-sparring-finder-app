import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sparring_finder/src/ui/skeletons/chat_list_skeleton_screen.dart';
import 'package:sparring_finder/src/ui/widgets/text_auto_scroll.dart';

import '../../../blocs/conversation/conversation_bloc.dart';
import '../../../blocs/conversation/conversation_event.dart';
import '../../../blocs/conversation/conversation_state.dart';
import '../../../models/conversation/conversation_model.dart';
import '../../../repositories/conversation_repository.dart';
import '../../../services/api_service.dart';
import '../../theme/app_colors.dart';
import 'chat_screen.dart';

/// ChatListScreen displays all conversations for the authenticated user.
/// It uses ConversationBloc to load data and responds to real‐time updates.
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ConversationBloc _conversationBloc;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();

    // Build the ConversationRepository from the shared ApiService
    final apiService = Provider.of<ApiService>(context, listen: false);
    final conversationRepo = ConversationRepository(apiService: apiService);

    // Create and load the bloc
    _conversationBloc = ConversationBloc(repository: conversationRepo)
      ..add(const LoadConversations());

    // Listen to search‐text changes
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _conversationBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationBloc>.value(
      value: _conversationBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top / 2),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: AppColors.text),
                          cursorColor: Colors.redAccent,
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            hintText: 'Search chat',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.top / 4),
              Expanded(
                child: BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, state) {
                    if (state is ConversationLoadInProgress) {
                      return ChatListSkeletonScreen();
                    } else if (state is ConversationLoadSuccess) {
                      // Optionally filter by search text
                      final allConvos = state.conversations;
                      final filtered = _searchText.isEmpty
                          ? allConvos
                          : allConvos.where((c) {
                              return c.name.toLowerCase().contains(_searchText);
                            }).toList();

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text(
                            'No conversations yet',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (_, __) => const Divider(
                          color: Color(0xFF3A3A3A),
                          thickness: 0.5,
                          height: 0.5,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final convo = filtered[index];
                          return _buildConversationItem(convo);
                        },
                      );
                    } else if (state is ConversationFailure) {
                      return Center(
                        child: Text(
                          'Error: ${state.error}',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a single conversation item, with swipe actions.
  Widget _buildConversationItem(ConversationModel convo) {
    return Slidable(
      key: ValueKey(convo.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.40, // ~40% of item width for two buttons
        children: [
          SlidableAction(
            onPressed: (context) {
              // TODO: handle “More” tap
            },
            flex: 1,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            label: 'More',
          ),
          SlidableAction(
            onPressed: (context) {
              // TODO: handle “Archive” tap
            },
            flex: 1,
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            label: 'Archive',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                conversationId: convo.id,
                conversationName: convo.name,
              ),
            ),
          );
        },
        child: Container(
          color: AppColors.inputFill,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(convo.avatarUrl),
              ),
              const SizedBox(width: 12),

              // Name + last message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      convo.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Last message
                    Text(
                      convo.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Spacer
              const SizedBox(width: 8),

              // Time & unread badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Time
                  Text(
                    _formatTime(convo.lastSentAt),
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Unread badge
                  if (convo.unreadCount > 0)
                    Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: TextAutoScroll(
                          text: convo.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats DateTime into “hh:mm AM/PM” or “MM/dd/yyyy” if older than today
  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final local = dt.toLocal();
    final diff = now.difference(local);

    if (diff.inDays >= 1) {
      // Show date if not today
      return '${local.month}/${local.day}/${local.year}';
    }

    final hour = (local.hour == 0)
        ? 12
        : (local.hour > 12 ? local.hour - 12 : local.hour);
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
