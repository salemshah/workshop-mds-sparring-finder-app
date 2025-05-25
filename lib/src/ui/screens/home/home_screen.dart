import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/src/ui/skeletons/home_screen_skeleton.dart';
import 'package:sparring_finder/src/ui/widgets/text_auto_scroll.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../config/app_routes.dart';
import '../../../models/profile/profile_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/athlete_card.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../../utils/jwt.dart';

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

  // ----------------------------- Init ------------------------------------- //
  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();

    if (!_hasFetched) {
      context.read<ProfileBloc>().add(const ProfilesFetchedAll());
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
        context.read<ProfileBloc>().add(const ProfilesFetchedAll());
      } else {
        context.read<ProfileBloc>().add(ProfilesSearched(query.trim()));
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

    context.read<ProfileBloc>().add(const ProfilesFetchedAll());
    setState(() {});
  }

  void _showFilterBottomSheet() {
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileListLoadSuccess) {
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

          context.read<ProfileBloc>().add(
                ProfilesFiltered(
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
            padding: EdgeInsets.only(top: 15),
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
                  context.read<ProfileBloc>().add(
                        FavoriteToggled(
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
                      AppColors.background.withValues(alpha: .0),
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

  // ------------------------------- Header ---------------------------------- //

  Widget _header(double statusBarHeight, String firstName, String lastName,
      String photoUrl) {
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight, left: 14, right: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.text, width: 2),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColors.inputFill,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextAutoScroll(
                        text: firstName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      TextAutoScroll(
                        text: lastName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_active,
                      color: AppColors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Text(
            "SPARRING FINDER",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const Text(
            "Find your ideal partner for sparring!",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.text, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _searchAndFilters() {
    // ----------------------- Search & Filters -------------------- //
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
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
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------- Build ---------------------------------- //
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // ----------------------- List ------------------------------- //
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        Widget header;
        Widget body;

        if (state is ProfileLoadInProgress) {
          return HomeScreenSkeleton();
        } else if (state is ProfileListLoadSuccess) {
          body = _buildProfileList(state.profiles);

          Profile? profile = state.profiles.firstWhereOrNull(
            (profile) => profile.userId == _currentUserId,
          );

          final firstName = profile?.firstName.capitalizeEachWord() ?? '';
          final lastName = profile?.lastName.capitalizeEachWord() ?? '';

          if (profile == null) {
            header = SizedBox();
          } else {
            header = _header(
                statusBarHeight, firstName, lastName, profile.photoUrl!);
          }
        } else if (state is ProfileFailure) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else {
          header = SizedBox();
          body = SizedBox();
        }

        return Column(
          children: [
            header,
            SizedBox(height: 20.h),
            _searchAndFilters(),
            Expanded(child: body)
          ],
        );
      },
    );
  }
}
