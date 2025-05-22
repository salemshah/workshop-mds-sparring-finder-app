import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sparring_finder/src/blocs/availability/availability_bloc.dart';
import 'package:sparring_finder/src/models/availability/availability_model.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/ui/widgets/text_auto_scroll.dart';
import '../../../blocs/availability/availability_event.dart';
import '../../../blocs/availability/availability_state.dart';
import '../../theme/app_colors.dart';

class AvailabilityListScreen extends StatelessWidget {
  const AvailabilityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<AvailabilityBloc, AvailabilityState>(
          listener: (context, state) {
            if (state is AvailabilityFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
            if (state is AvailabilityOperationSuccess) {
              // after create / update / delete → refresh list
              context.read<AvailabilityBloc>().add(const LoadAvailabilities());
            }
          },
          builder: (context, state) {
            if (state is AvailabilityLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AvailabilityLoadSuccess) {
              if (state.availabilities.isEmpty) {
                return const Center(
                  child: Text('No availabilities yet', style: TextStyle(color: AppColors.text)),
                );
              }
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Text("My Availability", style: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: state.availabilities.length,
                    separatorBuilder: (_, __) =>  SizedBox(height: 5),//const Divider(height: 0, color: AppColors.border),
                    itemBuilder: (context, i) => _AvailabilityTile(slot: state.availabilities[i]),
                  ),
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.availabilityFormScreen),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

/* ----------------------------------------------------------------------- */
/*                                 Tile                                    */
/* ----------------------------------------------------------------------- */

class _AvailabilityTile extends StatelessWidget {
  const _AvailabilityTile({required this.slot});
  final Availability slot;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AvailabilityBloc>();
    final dateFmt = DateFormat('dd MMM, yyyy');
    final timeFmt = DateFormat('hh:mm a');

    return Slidable(
      key: ValueKey(slot.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.46, // width of both buttons
        children: [
          SlidableAction(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (_) => bloc.add(DeleteAvailability(slot.id)),
          ),
          SlidableAction(
            backgroundColor: Colors.blueAccent,
            foregroundColor: AppColors.background,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (_) {
              Navigator.pushNamed(
                context,
                AppRoutes.availabilityFormScreen,
                arguments: slot,
              );
            },
          ),
        ],
      ),
      child: Container(
        color: AppColors.inputFill,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dateFmt.format(slot.specificDate),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${timeFmt.format(slot.startTime)}  -  ${timeFmt.format(slot.endTime)}',
                  style:  TextStyle(color: AppColors.text, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_pin, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: TextAutoScroll(text: slot.location, style: TextStyle(color: AppColors.text, fontSize: 12),)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
