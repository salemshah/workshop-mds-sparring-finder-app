import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_event.dart';
import 'package:sparring_finder/src/blocs/availability/availability_state.dart';
import 'package:sparring_finder/src/models/availability/availability_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../theme/app_colors.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final List<TimeRegion> selectedTimeRegions = [];
  late final List<TimeRegion> blockedTimeRegions;
  List<TimeRegion>? availableTimeRegions;

  @override
  void initState() {
    super.initState();
    context.read<AvailabilityBloc>().add(LoadAvailabilities());
  }

  TimeRegion _timeRegionToAvailability(Availability a) {
    return TimeRegion(
      startTime: DateTime(a.specificDate.year, a.specificDate.month, a.specificDate.day, a.startTime.hour, a.startTime.minute),
      endTime: DateTime(a.specificDate.year, a.specificDate.month, a.specificDate.day, a.endTime.hour, a.endTime.minute),
      enablePointerInteraction: true,
      color: Colors.blue.withValues(alpha: 0.1),
      timeZone: 'Europe/Paris',
      text: 'Available times',
      textStyle: TextStyle(
        color: AppColors.text,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<AvailabilityBloc, AvailabilityState>(
          builder: (context, state) {
            if (state is AvailabilityLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AvailabilityFailure) {
              return Center(child: Text(state.error, style: const TextStyle(color: AppColors.text)));
            }

            if (state is AvailabilityLoadSuccess) {
              if (state.availabilities.isEmpty) {
                return const Center(child: Text('No availabilities yet', style: TextStyle(color: AppColors.text)));
              }

              availableTimeRegions = state.availabilities.map(_timeRegionToAvailability).toList();
              // blockedTimeRegions = buildBlockedRegions(availableTimeRegions!); // Optional if needed
            }

            if (availableTimeRegions == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SfCalendar(
              view: CalendarView.day,
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeInterval: Duration(minutes: 60),
                timeTextStyle: TextStyle(color: AppColors.primary),
              ),
              headerStyle: CalendarHeaderStyle(
                backgroundColor: AppColors.inputFill,
                textStyle: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selectionDecoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2),
              ),
              cellBorderColor: AppColors.border,
              todayHighlightColor: AppColors.primary,

              specialRegions: [
                // ...blockedTimeRegions, // Uncomment if using blocked regions
                ...availableTimeRegions!,
                ...selectedTimeRegions,
              ],

              onTap: (CalendarTapDetails details) async {
                final tap = details.date;
                if (tap == null) return;

                final tappedRes = selectedTimeRegions.firstWhereOrNull(
                      (r) =>
                  tap.isAfter(r.startTime.subtract(const Duration(minutes: 1))) &&
                      tap.isBefore(r.endTime),
                );
                if (tappedRes != null) {
                  await _editReservation(tappedRes);
                  return;
                }

                final activeAvail = availableTimeRegions!.firstWhereOrNull(
                      (r) =>
                  tap.isAfter(r.startTime.subtract(const Duration(minutes: 1))) &&
                      tap.isBefore(r.endTime),
                );
                if (activeAvail == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text('Tap only inside available times.'),
                    ),
                  );
                  return;
                }

                await _createReservation(tap, activeAvail.endTime);
              },
            );
          },
        ),
      ),
    );
  }

  // ───────────────────────── Helpers ─────────────────────────

  Future<void> _createReservation(DateTime start, DateTime maxEnd) async {
    // build end-time dropdown: every 30-minute step until maxEnd
    final endOptions = <DateTime>[];
    DateTime cursor = start.add(const Duration(minutes: 30));
    while (!cursor.isAfter(maxEnd)) {
      endOptions.add(cursor);
      cursor = cursor.add(const Duration(minutes: 30));
    }
    var selectedEnd = endOptions.first;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        DateTime tempSelectedEnd = endOptions.first;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('New reservation'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Start: ${TimeOfDay.fromDateTime(start).format(context)}'),
                  const SizedBox(height: 12),
                  const Text('End time:'),
                  DropdownButton<DateTime>(
                    value: tempSelectedEnd,
                    isExpanded: true,
                    items: endOptions
                        .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(TimeOfDay.fromDateTime(d).format(context))))
                        .toList(),
                    onChanged: (d) {
                      if (d != null) {
                        setState(() => tempSelectedEnd = d);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectedEnd = tempSelectedEnd;
                    Navigator.pop(context, true);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        selectedTimeRegions.add(TimeRegion(
          startTime: start,
          endTime: selectedEnd,
          enablePointerInteraction: true,
          color: AppColors.primary.withValues(alpha: .80),
          text: 'Reserved',
          textStyle: TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          )
        ));
      });
    }
  }

  Future<void> _editReservation(TimeRegion reservation) async {
    DateTime start = reservation.startTime;
    DateTime selectedEnd = reservation.endTime;

    // end options limited to the availability window that contains this res.
    final avail = availableTimeRegions?.firstWhere(
            (a) => start.isAfter(a.startTime.subtract(const Duration(minutes: 1))) &&
            start.isBefore(a.endTime));
    final endOptions = <DateTime>[];
    DateTime cursor = start.add(const Duration(minutes: 30));
    while (!cursor.isAfter(avail!.endTime)) {
      endOptions.add(cursor);
      cursor = cursor.add(const Duration(minutes: 30));
    }

    final action = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit / Cancel reservation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Start: ${TimeOfDay.fromDateTime(start).format(context)}'),
            const SizedBox(height: 12),
            const Text('End:'),
            StatefulBuilder(
              builder: (context, setState) => DropdownButton<DateTime>(
                value: selectedEnd,
                isExpanded: true,
                items: endOptions
                    .map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(TimeOfDay.fromDateTime(d).format(context))))
                    .toList(),
                onChanged: (d) {
                  if (d != null) {
                    setState(() {
                      selectedEnd = d;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, 'delete'),
              child: const Text('Delete')),
          TextButton(onPressed: () => Navigator.pop(context, null),
              child: const Text('Close')),
          ElevatedButton(onPressed: () => Navigator.pop(context, 'save'),
              child: const Text('Save')),
        ],
      ),
    );

    if (action == 'delete') {
      setState(() => selectedTimeRegions.remove(reservation));
    } else if (action == 'save') {
      setState(() {
        final idx = selectedTimeRegions.indexOf(reservation);
        selectedTimeRegions[idx] = TimeRegion(
          startTime: start,
          endTime: selectedEnd,
          enablePointerInteraction: true,
          color: AppColors.primary.withOpacity(.40),
          text: 'Reserved',
        );
      });
    }
  }
}




/// this used to block the time regions

// ...blockedTimeRegions, // specialRegions: [...blockedTimeRegions, ...availableTimeRegions, ...selectedTimeRegions,],

// blockedTimeRegions = buildBlockedRegions(availableTimeRegions); // inside this void initState(){ }

// /// Build “blocked” grey bands for **every** day represented in [available].
// ///
// /// * Works even if `available` spans several days.
// /// * Automatically merges overlapping / touching availability windows.
// /// * Returns one `TimeRegion` list you can feed straight into `specialRegions`.
// List<TimeRegion> buildBlockedRegions(List<TimeRegion> available) {
//   if (available.isEmpty) return const [];
//
//   // 1️⃣  Group availability windows by (year, month, day).
//   final Map<DateTime, List<TimeRegion>> byDay = {};
//   for (final slot in available) {
//     final DateTime dayKey =
//     DateTime(slot.startTime.year, slot.startTime.month, slot.startTime.day);
//     byDay.putIfAbsent(dayKey, () => []).add(slot);
//   }
//
//   final List<TimeRegion> blocked = [];
//
//   for (final entry in byDay.entries) {
//     final DateTime day = entry.key;
//     final List<TimeRegion> dailyAvail = _mergeAndSort(entry.value);
//
//     DateTime cursor = DateTime(day.year, day.month, day.day, 0, 0);
//
//     // Add a grey band for every gap before each availability window.
//     for (final slot in dailyAvail) {
//       if (cursor.isBefore(slot.startTime)) {
//         blocked.add(_grey(cursor, slot.startTime));
//       }
//       cursor = slot.endTime;
//     }
//
//     // Add final grey band after the last availability window.
//     final DateTime endOfDay = DateTime(day.year, day.month, day.day, 23, 59);
//     if (cursor.isBefore(endOfDay)) {
//       blocked.add(_grey(cursor, endOfDay));
//     }
//   }
//
//   return blocked;
// }
//
// /// Merge overlapping or back-to-back availability windows, then sort them.
// List<TimeRegion> _mergeAndSort(List<TimeRegion> slots) {
//   if (slots.isEmpty) return [];
//
//   slots.sort((a, b) => a.startTime.compareTo(b.startTime));
//   final merged = <TimeRegion>[slots.first];
//
//   for (var i = 1; i < slots.length; i++) {
//     final last = merged.last;
//     final current = slots[i];
//
//     // Windows overlap or touch → extend the last one.
//     if (!current.startTime.isAfter(last.endTime)) {
//       merged[merged.length - 1] = TimeRegion(
//         startTime: last.startTime,
//         endTime:
//         current.endTime.isAfter(last.endTime) ? current.endTime : last.endTime,
//         enablePointerInteraction: true,
//         color: last.color,
//         text: last.text,
//       );
//     } else {
//       merged.add(current);
//     }
//   }
//   return merged;
// }
//
// /// Convenience constructor for a grey blocked band.
// TimeRegion _grey(DateTime from, DateTime to) => TimeRegion(
//   startTime: from,
//   endTime: to,
//   enablePointerInteraction: false,
//   color: Colors.grey.withOpacity(.30),
//   text: 'Blocked',
// );
