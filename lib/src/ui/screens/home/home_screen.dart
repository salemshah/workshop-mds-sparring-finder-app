import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/athlete_card.dart';
import '../../widgets/bottom_navi_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileListRequested());
  }
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        context.read<ProfileBloc>().add(ProfileListRequested());
      } else {
        context.read<ProfileBloc>().add(ProfileSearchRequested(query: query.trim()));
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/boxer.png',
                    width: width - 50,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Search profil partner',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.notifications, size: 30),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.inputFill,
                      hintText: 'Search by name, city, level...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Athletes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfilesLoaded) {
                    final profiles = state.profiles;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        itemCount: profiles.length,
                        padding: const EdgeInsets.only(bottom: 40),
                        itemBuilder: (context, index) {
                          final p = profiles[index];
                          return AthleteCard(
                            name: "${p.firstName} ${p.lastName}",
                            weight: p.weightClass,
                            city: p.city,
                            level: p.skillLevel,
                            image: p.photoUrl,
                            isFavorite: false,
                          );
                        },
                      ),
                    );
                  } else if (state is ProfileSearchSuccess) {
                    final results = state.results;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        itemCount: results.length,
                        padding: const EdgeInsets.only(bottom: 40),
                        itemBuilder: (context, index) {
                          final p = results[index];
                          return AthleteCard(
                            name: "${p.firstName} ${p.lastName}",
                            weight: p.weightClass,
                            city: p.city,
                            level: p.skillLevel,
                            image: p.photoUrl,
                            isFavorite: false,
                          );
                        },
                      ),
                    );
                  } else if (state is ProfileFailure) {
                    return Center(
                      child: Text(
                        "Error: ${state.error}",
                        style: const TextStyle(color: Colors.white),
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
    );
  }
}