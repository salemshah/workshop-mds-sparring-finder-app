import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../config/app_routes.dart';
import '../../../models/profile/profile_model.dart';

class AthleteDetailsPage extends StatelessWidget {
  static const routeName = '/athlete';
  final Profile profile;

  const AthleteDetailsPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _AthleteDetailsBody(profile: profile),
    );
  }
}

class _AthleteDetailsBody extends StatelessWidget {
  final Profile profile;
  const _AthleteDetailsBody({required this.profile});


  int get age {
    final now = DateTime.now();
    int years = now.year - profile.dateOfBirth.year;
    if (now.month < profile.dateOfBirth.month ||
        (now.month == profile.dateOfBirth.month && now.day < profile.dateOfBirth.day)) {
      years -= 1;
    }
    return years;
  }

  String get yearsExperience => profile.yearsExperience;

  List<String> get styleList =>
      profile.preferredStyles.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
                  Image.network(profile.photoUrl!, fit: BoxFit.cover)
                else
                  Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.35)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${profile.firstName} ${profile.lastName}'.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    '${profile.bio ?? 'Verified MMA fighter'} from ${profile.city}, ${profile.country}. '
                        '${profile.weightClass} class, $yearsExperience years experience, skilled in ${styleList.join(', ')}.',
                    style: TextStyle(color: AppColors.text, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ActionButton(
                      icon: Icons.message,
                      label: 'Message',
                      onPressed: () {}, // TODO: add message action
                    ),
                    _ActionButton(
                      icon: Icons.favorite,
                      label: 'Add',
                      onPressed: () => context.read<ProfileBloc>().add(
                        FavoriteToggled(
                          targetUserId: profile.userId,
                          currentUserId: 0, // TODO: replace with actual logged-in user ID
                        ),
                      ),
                    ),
                    _ActionButton(
                      icon: Icons.person_add_alt_1,
                      label: 'Invite',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.availabilityListScreen, arguments: profile.userId);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _InfoRow(icon: Icons.verified, iconColor: Colors.blue, title: 'License', value: 'Verified'),
                _InfoRow(icon: Icons.signal_cellular_alt_rounded, title: 'Level', value: profile.skillLevel),
                _InfoRow(icon: Icons.cake_rounded, title: 'Age', value: '$age Years'),
                _InfoRow(icon: Icons.fitness_center_rounded, title: 'Weight Class', value: profile.weightClass.limit(10).capitalizeEachWord()),
                _InfoRow(icon: Icons.calendar_month_rounded, title: 'Experience', value: yearsExperience),
                _InfoRow(icon: Icons.interests_rounded, title: 'Styles', value: styleList.toString().limit(22)),
                _InfoRow(icon: profile.gender == "Female" ?Icons.female_rounded :Icons.male_rounded, title: 'Gender', value: profile.gender.capitalizeEachWord()),
                _InfoRow(icon: Icons.fmd_bad_rounded, title: 'Gym', value: profile.gymName.limit(15).capitalizeEachWord()),
                _InfoRow(icon: Icons.location_city_rounded, title: 'Location', value: profile.city.limit(10).capitalizeEachWord()),
                _InfoRow(icon: Icons.flag_circle_rounded, title: 'Location', value: profile.country.limit(15).capitalizeEachWord()),
                _InfoRow(icon: Icons.link, title: 'Joined', value: '${profile.createdAt.month.toString().padLeft(2, '0')}/${profile.createdAt.year}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  const _InfoRow({required this.title, required this.value, required this.icon, this.iconColor = AppColors.primary});

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
            SizedBox(width: 4),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.text, fontSize: 12))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.text, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _ActionButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: Icon(icon, size: 18),
          label: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.white)),
        ),
      ),
    );
  }
}
