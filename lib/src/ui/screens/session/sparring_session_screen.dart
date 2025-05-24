import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/sparring/sparring_bloc.dart';
import 'package:sparring_finder/src/blocs/sparring/sparring_event.dart';
import 'package:sparring_finder/src/blocs/sparring/sparring_state.dart';
import 'package:sparring_finder/src/models/sparring/sparring_model.dart';
import 'package:sparring_finder/src/ui/widgets/sparring_card.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import '../../theme/app_colors.dart';

class SparringSessionScreen extends StatelessWidget {
  const SparringSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SparringBloc(repository: context.read())..add(LoadSparrings()),
      child: const SparringSessionBody(),
    );
  }
}

class SparringSessionBody extends StatelessWidget {
  const SparringSessionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ---------------- Header ----------------
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('SPARRING',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text('FINDER',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/boxer.png'),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Session',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ---------------- Tab Bar ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.text,
                    tabs: const [
                      Tab(text: 'Confirmed'),
                      Tab(text: 'Suspend'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ---------------- TabBar View ----------------
              Expanded(
                child: BlocBuilder<SparringBloc, SparringState>(
                  builder: (context, state) {
                    if (state is SparringLoadInProgress) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is SparringLoadSuccess) {
                      return TabBarView(
                        children: [
                          _buildSessionList(state.sparrings, 'CONFIRMED'),
                          _buildSessionList(state.sparrings, 'PENDING'),
                          _buildSessionList(state.sparrings, 'CANCELLED'),
                        ],
                      );
                    } else if (state is SparringFailure) {
                      return Center(
                          child: Text(
                        state.error,
                        style: const TextStyle(color: AppColors.primary),
                      ));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionList(List<Sparring> sessions, String status) {
    final filtered =
        sessions.where((s) => s.status.toUpperCase() == status).toList();

    if (filtered.isEmpty) {
      return const Center(
        child:
            Text('There no session', style: TextStyle(color: AppColors.text)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (_, index) {
        final session = filtered[index];
        final requested = session.requesterProfile;
        final partner = session.partnerProfile;

        return SparringCard(
          firstName: requested?.firstName.capitalizeEachWord() ?? '',
          lastName: requested?.lastName.capitalizeEachWord()  ?? '',
          age: _calculateAge(requested?.dateOfBirth),
          photoUrl: requested?.photoUrl ?? '',
          scheduledDate: session.scheduledDate.date,
          location: session.location.capitalizeEachWord() ,
          startTime: session.startTime.time,
          invitedFirstName: partner?.firstName.capitalizeEachWord()  ?? '',
          invitedLastName: partner?.lastName.capitalizeEachWord()  ?? '',
          invitedAge: _calculateAge(partner?.dateOfBirth),
          invitedPhotoUrl: partner?.photoUrl ?? '',
          cardStatus: session.status,
        );
      },
    );
  }


  String _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return '';
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }
}
