import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/ui/skeletons/home/home_athlete_skeleton.dart';

import '../../../blocs/athletes/athletes_bloc.dart';
import '../../../blocs/athletes/athletes_event.dart';
import '../../../blocs/athletes/athletes_state.dart';
import '../../../config/app_routes.dart';
import '../../../models/profile/profile_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/athlete_card.dart';
import '../../../utils/jwt.dart';

/// Discovery screen: browse, search & filter athletes.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  int? _currentUserId;



  // ----------------------------- Init ------------------------------------- //
  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();

    if (!_hasFetched) {
      context.read<AthletesBloc>().add(const AthletesFetched());
      _hasFetched = true;
    }
  }

  Future<void> _loadUserId() async {
    final storage = await JwtStorageHelper.getDecodedAccessToken();
    setState(() => _currentUserId = storage['id'] as int?);
  }

  // ----------------------- Favorites Helper ------------------------------ //
  Set<int> _currentUserFavoriteIds(List<Profile> profiles) {
    if (_currentUserId == null) return {};
    for (final p in profiles) {
      if (p.userId == _currentUserId) {
        return p.favorites.map((f) => f.favoritedUserId).toSet();
      }
    }
    return {};
  }

  // ----------------------------- List ------------------------------------- //
  Widget _buildProfileList(List<Profile> profiles) {
    final favoriteIds = _currentUserFavoriteIds(profiles);
    // Filtrer uniquement les profils favoris et exclure l'utilisateur connecté
    final favoriteProfiles = profiles
        .where((p) => favoriteIds.contains(p.userId) && p.userId != _currentUserId)
        .toList();

    if (favoriteProfiles.isEmpty) {
      return Center(
        child: Text(
          "No favorites yet!",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 15),
            itemCount: favoriteProfiles.length,
            itemBuilder: (context, index) {
              final p = favoriteProfiles[index];
              return AthleteCard(
                name: '${p.firstName} ${p.lastName}',
                weight: p.weightClass,
                city: p.city,
                level: p.skillLevel,
                image: p.photoUrl,
                gender: p.gender,
                isFavorite: true,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.athleteDetailsScreen,
                    arguments: p,
                  );
                },
                onFavoriteToggle: () {
                  context.read<AthletesBloc>().add(
                        FavoriteToggledForAthlete(
                          targetUserId: p.userId,
                          currentUserId: _currentUserId ?? 0,
                        ),
                      );
                },
              );
            },
          ),

          // Top fade effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 15, // height of fade
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background,
                      AppColors.background.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------- Build ---------------------------------- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mes favoris',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [

          // --------------------------------- Athletes ----------------------------------///
          Expanded(
            child: BlocBuilder<AthletesBloc, AthletesState>(
              builder: (context, state) {
                if (state is AthletesLoadInProgress) {
                  return const HomeAthleteSkeleton();
                } else if (state is AthletesLoadSuccess) {
                  return _buildProfileList(state.profiles);
                } else if (state is AthletesFailure) {
                  return Center(
                    child: Text(
                      'Error: ${state.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
