import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sparring_finder/src/blocs/availability/availability_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_event.dart';
import 'package:sparring_finder/src/blocs/availability/availability_state.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/models/availability/availability_model.dart';
import 'package:sparring_finder/src/ui/widgets/text_auto_scroll.dart';
import '../../theme/app_colors.dart';

class AvailabilityListScreen extends StatefulWidget {
  /// Pass `targetUserId` via Navigator to view another athlete’s availabilities.
  const AvailabilityListScreen({super.key, this.targetUserId});

  final int? targetUserId;

  @override
  State<AvailabilityListScreen> createState() => _AvailabilityListScreenState();
}

class _AvailabilityListScreenState extends State<AvailabilityListScreen> {
  bool get viewingMine => widget.targetUserId == null;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AvailabilityBloc>();
    if (viewingMine) {
      bloc.add(const LoadAvailabilities());
    } else {
      bloc.add(LoadAvailabilitiesByTargetUserId(widget.targetUserId!));
    }
  }


  @override
  Widget build(BuildContext context) {

    if(viewingMine) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: _body(),
          floatingActionButton: FloatingActionButton(onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.availabilityFormScreen),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      );
    }else{
      return Scaffold(
        // appBar: AppBar(backgroundColor: AppColors.background,),
        backgroundColor: AppColors.background,
        body: SafeArea(child: _body()),
      );
    }
  }

  _body () {
    return BlocConsumer<AvailabilityBloc, AvailabilityState>(
      listener: (context, state) {
        if (state is AvailabilityFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
        if (state is AvailabilityOperationSuccess && viewingMine) {
          // refresh only in "my" mode
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
              child: Text('No availabilities yet',
                  style: TextStyle(color: AppColors.text)),
            );
          }
          return Column(
            children: [
              if (!viewingMine) Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: AppColors.text, size: 23,),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: TextAutoScroll(text: "Athlete Availability", height: 40, style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                      ),
                    )
                )
                ,
              ]),
              if(viewingMine) Text("My Availability",
                  style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: state.availabilities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemBuilder: (context, i) => _AvailabilityTile(
                    slot: state.availabilities[i],
                    mine: viewingMine,
                  ),
                ),
              ),
              // Expanded(child: TimetableScreen())
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/* ----------------------------------------------------------------------- */
/*                                 Tile                                    */
/* ----------------------------------------------------------------------- */

class _AvailabilityTile extends StatelessWidget {
  const _AvailabilityTile({required this.slot, required this.mine});

  final Availability slot;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AvailabilityBloc>();
    final dateFmt = DateFormat('dd MMM, yyyy');
    final timeFmt = DateFormat('hh:mm a');

    return Slidable(
      key: ValueKey(slot.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: mine ? 0.46 : 0.25,
        children: mine
            ? [
          // -------------------- Delete --------------------
          SlidableAction(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (_) => bloc.add(DeleteAvailability(slot.id)),
          ),
          // --------------------- Edit ---------------------
          SlidableAction(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (_) => Navigator.pushNamed(
              context,
              AppRoutes.availabilityFormScreen,
              arguments: slot,
            ),
          ),
        ]
            : [
          // -------------------- Request -------------------
          SlidableAction(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.send,
            label: 'Request',
            onPressed: (_) {
              // TODO: dispatch a sparring request event
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request sent')),
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
                  style: const TextStyle(color: AppColors.text, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_pin,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: TextAutoScroll(
                    text: slot.location,
                    style:
                    const TextStyle(color: AppColors.text, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
