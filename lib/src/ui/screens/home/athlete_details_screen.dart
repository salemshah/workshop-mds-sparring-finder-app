import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import 'package:sparring_finder/src/utils/jwt.dart';
import '../../../blocs/conversation/conversation_bloc.dart';
import '../../../blocs/conversation/conversation_event.dart';
import '../../../blocs/conversation/conversation_state.dart';
import '../../../blocs/athletes/athletes_bloc.dart';
import '../../../blocs/athletes/athletes_event.dart';
import '../../../config/app_routes.dart';
import '../../../models/profile/profile_model.dart';
import '../message/chat_screen.dart';

class AthleteDetailsScreen extends StatelessWidget {
  static const routeName = '/athlete';
  final Profile profile;

  const AthleteDetailsScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _AthleteDetailsBody(profile: profile),
    );
  }
}

class _AthleteDetailsBody extends StatefulWidget {
  final Profile profile;

  const _AthleteDetailsBody({required this.profile});

  @override
  State<_AthleteDetailsBody> createState() => _AthleteDetailsBodyState();
}

class _AthleteDetailsBodyState extends State<_AthleteDetailsBody> {
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    final userInfo = await JwtStorageHelper.getDecodedAccessToken();
    setState(() {
      _currentUserId = userInfo["id"] as int;
    });
  }

  int get age {
    final now = DateTime.now();
    int years = now.year - widget.profile.dateOfBirth.year;
    if (now.month < widget.profile.dateOfBirth.month ||
        (now.month == widget.profile.dateOfBirth.month &&
            now.day < widget.profile.dateOfBirth.day)) {
      years -= 1;
    }
    return years;
  }

  String get yearsExperience => widget.profile.yearsExperience;

  List<String> get styleList => widget.profile.preferredStyles
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationCreateSuccess) {
          final convoId = state.newConversation.id;
          final convoName =
              '${widget.profile.firstName} ${widget.profile.lastName}';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                conversationId: convoId,
                conversationName: convoName,
              ),
            ),
          );
        } else if (state is ConversationFailure) {
          print(state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start chat: ${state.error}'),
            ),
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.profile.photoUrl != null &&
                      widget.profile.photoUrl!.isNotEmpty)
                    Image.network(widget.profile.photoUrl!, fit: BoxFit.cover)
                  else
                    Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  Container(color: Colors.black.withOpacity(0.35)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.profile.firstName} ${widget.profile.lastName}'
                          .toUpperCase(),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      textAlign: TextAlign.center,
                      '${widget.profile.bio ?? 'Verified MMA fighter'} from ${widget.profile.city}, ${widget.profile.country}. '
                      '${widget.profile.weightClass} class, $yearsExperience years experience, skilled in ${styleList.join(', ')}.',
                      style: TextStyle(color: AppColors.text, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _ActionButton(
                        icon: Icons.message,
                        label: 'Message',
                        onPressed: (_currentUserId == null ||
                                widget.profile.userId == _currentUserId)
                            ? null
                            : () {
                                final myId = _currentUserId!;
                                final otherId = widget.profile.userId;
                                context.read<ConversationBloc>().add(
                                      CreateConversation(
                                        participantIds: [myId, otherId],
                                        title: "Sparring",
                                        avatarUrl: widget.profile.photoUrl,
                                      ),
                                    );
                              },
                      ),
                      _ActionButton(
                        icon: Icons.favorite,
                        label: 'Add',
                        onPressed: () => context.read<AthletesBloc>().add(
                              FavoriteToggledForAthlete(
                                targetUserId: widget.profile.userId,
                                currentUserId: _currentUserId ?? -1,
                              ),
                            ),
                      ),
                      _ActionButton(
                        icon: Icons.person_add_alt_1,
                        label: 'Spar Invite',
                        onPressed: (widget.profile.userId != _currentUserId)
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.athleteAvailabilitiesCalenderScreen,
                                  arguments: widget.profile.userId,
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(
                    icon: Icons.verified,
                    iconColor: Colors.blue,
                    title: 'License',
                    value: 'Verified',
                  ),
                  _InfoRow(
                    icon: Icons.signal_cellular_alt_rounded,
                    title: 'Level',
                    value: widget.profile.skillLevel,
                  ),
                  _InfoRow(
                    icon: Icons.cake_rounded,
                    title: 'Age',
                    value: '$age Years',
                  ),
                  _InfoRow(
                    icon: Icons.fitness_center_rounded,
                    title: 'Weight Class',
                    value: widget.profile.weightClass
                        .limit(10)
                        .capitalizeEachWord(),
                  ),
                  _InfoRow(
                    icon: Icons.calendar_month_rounded,
                    title: 'Experience',
                    value: yearsExperience,
                  ),
                  _InfoRow(
                    icon: Icons.interests_rounded,
                    title: 'Styles',
                    value: styleList.toString().limit(22),
                  ),
                  _InfoRow(
                    icon: widget.profile.gender == "Female"
                        ? Icons.female_rounded
                        : Icons.male_rounded,
                    title: 'Gender',
                    value: widget.profile.gender.capitalizeEachWord(),
                  ),
                  _InfoRow(
                    icon: Icons.fmd_bad_rounded,
                    title: 'Gym',
                    value:
                        widget.profile.gymName.limit(15).capitalizeEachWord(),
                  ),
                  _InfoRow(
                    icon: Icons.location_city_rounded,
                    title: 'Location',
                    value: widget.profile.city.limit(10).capitalizeEachWord(),
                  ),
                  _InfoRow(
                    icon: Icons.flag_circle_rounded,
                    title: 'Country',
                    value:
                        widget.profile.country.limit(15).capitalizeEachWord(),
                  ),
                  _InfoRow(
                    icon: Icons.link,
                    title: 'Joined',
                    value:
                        '${widget.profile.createdAt.month.toString().padLeft(2, '0')}/${widget.profile.createdAt.year}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _InfoRow({
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? Colors.grey : AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
