import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/ui/screens/home/home_header.dart';
import 'package:sparring_finder/src/ui/skeletons/home/home_athlete_skeleton.dart';
import 'package:sparring_finder/src/ui/widgets/custom_toggle_switch.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../blocs/athletes/athletes_bloc.dart';
import '../../../blocs/athletes/athletes_event.dart';
import '../../../blocs/athletes/athletes_state.dart';
import '../../../config/app_routes.dart';
import '../../../models/profile/profile_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/athlete_card.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../../utils/jwt.dart';
import '../test/map_screen.dart';

/// Discovery screen: browse, search & filter athletes.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --------------------------- Controllers -------------------------------- //
  final _searchController = TextEditingController();
  final _levelController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _genderController = TextEditingController();

  Timer? _debounce;

  List<String> _levels = [];
  List<String> _countries = [];
  List<String> _cities = [];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  SfRangeValues _weightRange = const SfRangeValues(40.0, 150.0);
  int? _currentUserId;

  // Applied filters (for clear button)
  String? _appliedLevel;
  String? _appliedCountry;
  String? _appliedCity;
  String? _appliedGender;
  SfRangeValues _appliedWeightRange = const SfRangeValues(40.0, 150.0);

  bool get _isFilterActive =>
      _appliedLevel != null ||
      _appliedCountry != null ||
      _appliedCity != null ||
      _appliedGender != null ||
      _appliedWeightRange.start != 40.0 ||
      _appliedWeightRange.end != 150.0;

  // Track which “tab” is selected: 0 = list, 1 = map
  int _currentTabIndex = 0;

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

  // ----------------------------- Search ----------------------------------- //
  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        context.read<AthletesBloc>().add(const AthletesFetched());
      } else {
        context.read<AthletesBloc>().add(AthletesSearched(query.trim()));
      }
    });
  }

  // ----------------------------- Filters ---------------------------------- //
  void _clearFilters() {
    _levelController.clear();
    _countryController.clear();
    _cityController.clear();
    _genderController.clear();
    _weightRange = const SfRangeValues(40.0, 150.0);

    _appliedLevel = null;
    _appliedCountry = null;
    _appliedCity = null;
    _appliedGender = null;
    _appliedWeightRange = const SfRangeValues(40.0, 150.0);

    context.read<AthletesBloc>().add(const AthletesFetched());
    setState(() {});
  }

  void _showFilterBottomSheet() {
    final state = context.read<AthletesBloc>().state;
    if (state is AthletesLoadSuccess) {
      _levels = state.profiles.map((e) => e.skillLevel).toSet().toList();
      _countries = state.profiles.map((e) => e.country).toSet().toList();
      _cities = state.profiles.map((e) => e.city).toSet().toList();
    }

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (_) => FilterBottomSheet(
        levelController: _levelController,
        countryController: _countryController,
        cityController: _cityController,
        genderController: _genderController,
        levels: _levels,
        countries: _countries,
        cities: _cities,
        genders: _genders,
        selectedWeightRange: _weightRange,
        onWeightRangeChanged: (range) => setState(() => _weightRange = range),
        onApplyFilters: (
          String? level,
          String? country,
          String? city,
          String? gender,
          SfRangeValues? weightRange,
        ) {
          _appliedLevel = level?.isEmpty == true ? null : level;
          _appliedCountry = country?.isEmpty == true ? null : country;
          _appliedCity = city?.isEmpty == true ? null : city;
          _appliedGender = gender?.isEmpty == true ? null : gender;
          _appliedWeightRange = weightRange ?? const SfRangeValues(40.0, 150.0);

          context.read<AthletesBloc>().add(
                AthletesFiltered(
                  level: _appliedLevel,
                  country: _appliedCountry,
                  city: _appliedCity,
                  gender: _appliedGender,
                  minWeight: _appliedWeightRange.start,
                  maxWeight: _appliedWeightRange.end,
                ),
              );
          Navigator.pop(context);
          setState(() {});
        },
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 15),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final p = profiles[index];
              final isFavorite = favoriteIds.contains(p.userId);
              return AthleteCard(
                name: '${p.firstName} ${p.lastName}',
                weight: p.weightClass,
                city: p.city,
                level: p.skillLevel,
                image: p.photoUrl,
                gender: p.gender,
                isFavorite: isFavorite,
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

  // ------------- Search + Filters Row (with the toggle switch) ---------- //
  Widget _searchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
          // --- SEARCH BAR ROW ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.inputFill,
                    hintText: 'Search by name, city, level...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune_rounded,
                            color: AppColors.white),
                        onPressed: _showFilterBottomSheet,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // --- “Athletes” label, ToggleSwitch, Clear Filters button ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Athletes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _isFilterActive ? _clearFilters : null,
                icon: Icon(
                  Icons.clear,
                  color: _isFilterActive ? AppColors.white : Colors.white24,
                ),
                label: Text(
                  'Clear Filters',
                  style: TextStyle(
                    color: _isFilterActive ? AppColors.white : Colors.white24,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor:
                      _isFilterActive ? AppColors.primary : Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),

              CustomToggleSwitch(
                initialIndex: _currentTabIndex,
                onChanged: (newIndex) {
                  setState(() {
                    _currentTabIndex = newIndex;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------- Build ---------------------------------- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HomeHeader(search: _searchAndFilters()),

          // --------------------------------- Athletes ----------------------------------///
          Expanded(
            child: BlocBuilder<AthletesBloc, AthletesState>(
              builder: (context, state) {
                if (state is AthletesLoadInProgress) {
                  return const HomeAthleteSkeleton();
                } else if (state is AthletesLoadSuccess) {
                  // ── Use IndexedStack to keep both children mounted ──
                  return IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildProfileList(state.profiles),
                      MapScreen(state.profiles),
                    ],
                  );
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
