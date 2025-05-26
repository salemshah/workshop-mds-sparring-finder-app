import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../blocs/availability/availability_bloc.dart';
import '../../../blocs/availability/availability_event.dart';
import '../../../blocs/availability/availability_state.dart';
import '../../../models/availability/availability_model.dart';
import '../../theme/app_colors.dart';

class AvailabilityCalendarScreen extends StatefulWidget {
  const AvailabilityCalendarScreen({super.key});

  @override
  State<AvailabilityCalendarScreen> createState() =>
      _AvailabilityCalendarScreenState();
}

class _AvailabilityCalendarScreenState
    extends State<AvailabilityCalendarScreen> {
  /// All slots fetched from backend
  List<Availability> _availabilities = [];

  // -------------------------------------------------------------- Helpers --------------------------------------------------------------
  DateTime _toLocal(DateTime t) => t.isUtc ? t.toLocal() : t;

  DateTime _toUtc(DateTime t) => t.isUtc ? t : t.toUtc();

  bool _intervalsOverlap(
      DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
    return aStart.isBefore(bEnd) && bStart.isBefore(aEnd);
  }

  bool _overlapsExisting(DateTime start, DateTime end, List<Availability> list,
      [int? ignoreId]) {
    for (final a in list) {
      if (ignoreId != null && a.id == ignoreId) continue;
      if (_intervalsOverlap(
          start, end, _toLocal(a.startTime), _toLocal(a.endTime))) {
        return true;
      }
    }
    return false;
  }

  bool _isEndAfterStart(TimeOfDay start, TimeOfDay end) =>
      end.hour > start.hour;

  TimeOfDay _nextHourAfter(TimeOfDay t) =>
      TimeOfDay(hour: (t.hour + 1) % 24, minute: 0);

  TimeRegion _regionFromAvailability(Availability a) {
    final s = _toLocal(a.startTime);
    final e = _toLocal(a.endTime);
    return TimeRegion(
      startTime: s,
      endTime: e,
      enablePointerInteraction: true,
      color: AppColors.primary.withOpacity(0.8),
      timeZone: 'Europe/Paris',
      text: 'Available\n${a.location}',
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // -------------------------------------------------------------- Lifecycle --------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    context.read<AvailabilityBloc>().add(const LoadAvailabilities());
  }

  // -------------------------------------------------------------- UI --------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AvailabilityBloc, AvailabilityState>(
          listener: (context, state) {
            if (state is AvailabilityLoadSuccess ||
                state is AvailabilityOperationSuccess) {
              final list = (state is AvailabilityLoadSuccess)
                  ? state.availabilities
                  : (state as AvailabilityOperationSuccess).availabilities;
              setState(() => _availabilities = list);
            } else if (state is AvailabilityFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.primary,
              ));
            }
          },
          builder: (context, state) {
            final regions =
                _availabilities.map(_regionFromAvailability).toList();

// ----------------------------------------------------------- Sf Calendar ------------------------------------------------------------

            return SfCalendar(
              showNavigationArrow: true,
              showTodayButton: true,
              allowViewNavigation: true,
              viewHeaderStyle: const ViewHeaderStyle(
                dayTextStyle: TextStyle(
                  color: AppColors.text, //  Day name like "Mon"
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                dateTextStyle: TextStyle(
                  color: Colors.orangeAccent, // Date number like "24"
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              showDatePickerButton: true,
              monthViewSettings: const MonthViewSettings(
                showAgenda: true,
                dayFormat: 'EEE',
                monthCellStyle: MonthCellStyle(
                  textStyle: TextStyle(color: AppColors.primary),
                  // todayTextStyle: TextStyle(color: Colors.greenAccent),
                  leadingDatesTextStyle: TextStyle(color: AppColors.text),
                  trailingDatesTextStyle: TextStyle(color: AppColors.text),
                ),
                agendaStyle: AgendaStyle(
                  dayTextStyle: TextStyle(
                    color: Colors.greenAccent, // "Mon", "Tue", etc.
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  dateTextStyle: TextStyle(
                    color: AppColors.text, // Date number (e.g. "24")
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  appointmentTextStyle: TextStyle(
                    color: Colors.orange, // Event text
                  ),
                ),
              ),
              allowedViews: [
                CalendarView.day,
                CalendarView.month,
                CalendarView.week
              ],
              view: CalendarView.week,
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
              todayHighlightColor: AppColors.primary,
              cellBorderColor: AppColors.border,
              specialRegions: regions,
              onTap: (CalendarTapDetails details) async {
                final DateTime? tappedLocal = details.date;
                if (tappedLocal == null || tappedLocal.minute != 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Tap only on full-hour marks.'),
                    backgroundColor: Colors.redAccent,
                  ));
                  return;
                }

                // Which slot (if any) did we hit?
                final Availability? existing =
                    _availabilities.firstWhereOrNull((a) {
                  final s = _toLocal(a.startTime);
                  final e = _toLocal(a.endTime);
                  return tappedLocal.isAtSameMomentAs(s) ||
                      (tappedLocal.isAfter(s) && tappedLocal.isBefore(e));
                });

                if (existing != null) {
                  await _showEditOrDeleteDialog(existing);
                } else {
                  await _showCreateDialog(context, tappedLocal,
                      tappedLocal.add(const Duration(hours: 6)));
                }
              },
            );
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------- Dialogs --------------------------------------------------------------

  Future<void> _showCreateDialog(
      BuildContext context, DateTime base, DateTime maxEnd) async {
    final bloc = context.read<AvailabilityBloc>();
    final controller = TextEditingController(
        text: '22 Rue Allonvile, Paris, France'); // default
    final hours = List.generate(24, (i) => TimeOfDay(hour: i, minute: 0));

    TimeOfDay startT = TimeOfDay(hour: base.hour, minute: 0);
    TimeOfDay endT = TimeOfDay(hour: (base.hour + 1) % 24, minute: 0);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Start Time:'),
              DropdownButton<TimeOfDay>(
                value: startT,
                isExpanded: true,
                items: hours
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.format(context)),
                        ))
                    .toList(),
                onChanged: (t) {
                  if (t != null) {
                    setState(() {
                      startT = t;
                      if (!_isEndAfterStart(startT, endT)) {
                        endT = _nextHourAfter(startT);
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              const Text('End Time:'),
              DropdownButton<TimeOfDay>(
                value: endT,
                isExpanded: true,
                items: hours
                    .where((t) => _isEndAfterStart(startT, t))
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.format(context)),
                        ))
                    .toList(),
                onChanged: (t) {
                  if (t != null) setState(() => endT = t);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  final now = DateTime.now();
                  final start =
                      DateTime(base.year, base.month, base.day, startT.hour);
                  final end =
                      DateTime(base.year, base.month, base.day, endT.hour);

                  if (start.isBefore(now)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Cannot create in the past'),
                        backgroundColor: Colors.redAccent));
                    return;
                  }
                  if (!end.isAfter(start)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('End after start, please'),
                        backgroundColor: Colors.redAccent));
                    return;
                  }
                  if (_overlapsExisting(start, end, _availabilities)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Overlaps an existing slot'),
                        backgroundColor: Colors.redAccent));
                    return;
                  }
                  Navigator.pop(context, true);
                },
                child: const Text('Confirm')),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final startLocal = DateTime(base.year, base.month, base.day, startT.hour);
      final endLocal = DateTime(base.year, base.month, base.day, endT.hour);

      bloc.add(CreateAvailability({
        'specific_date': _toUtc(base).toIso8601String(),
        'start_time': _toUtc(startLocal).toIso8601String(),
        'end_time': _toUtc(endLocal).toIso8601String(),
        'location': controller.text,
      }));
    }
  }

  Future<void> _showEditOrDeleteDialog(Availability availability) async {
    final bloc = context.read<AvailabilityBloc>();
    final controller = TextEditingController(text: availability.location);

    final hours = List.generate(24, (i) => TimeOfDay(hour: i, minute: 0));
    TimeOfDay startT =
        TimeOfDay(hour: _toLocal(availability.startTime).hour, minute: 0);
    TimeOfDay endT =
        TimeOfDay(hour: _toLocal(availability.endTime).hour, minute: 0);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit / Delete Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Start Time:'),
              DropdownButton<TimeOfDay>(
                value: startT,
                isExpanded: true,
                items: hours
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.format(context)),
                        ))
                    .toList(),
                onChanged: (t) {
                  if (t != null) {
                    setState(() {
                      startT = t;
                      if (!_isEndAfterStart(startT, endT)) {
                        endT = _nextHourAfter(startT);
                      }
                    });
                  }
                },
              ),
              const Text('End Time:'),
              DropdownButton<TimeOfDay>(
                value: endT,
                isExpanded: true,
                items: hours
                    .where((t) => _isEndAfterStart(startT, t))
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.format(context)),
                        ))
                    .toList(),
                onChanged: (t) {
                  if (t != null) setState(() => endT = t);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'delete'),
                child: const Text('Delete')),
            TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  final now = DateTime.now();
                  final base = _toLocal(availability.startTime); // original day

                  final startLocal =
                      DateTime(base.year, base.month, base.day, startT.hour);
                  final endLocal =
                      DateTime(base.year, base.month, base.day, endT.hour);

                  if (startLocal.isBefore(now)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Cannot move into the past'),
                        backgroundColor: Colors.redAccent));
                    return;
                  }
                  if (!endLocal.isAfter(startLocal)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('End after start, please'),
                        backgroundColor: Colors.redAccent));
                    return;
                  }
                  if (_overlapsExisting(
                      startLocal, endLocal, _availabilities, availability.id)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Overlaps another slot'),
                        backgroundColor: Colors.redAccent));
                    return;
                  }
                  Navigator.pop(context, 'save');
                },
                child: const Text('Save')),
          ],
        ),
      ),
    );

    if (!mounted) return;

    final base = _toLocal(availability.startTime);
    final startLocal = DateTime(base.year, base.month, base.day, startT.hour);
    final endLocal = DateTime(base.year, base.month, base.day, endT.hour);

    if (result == 'delete') {
      bloc.add(DeleteAvailability(availability.id));
    } else if (result == 'save') {
      bloc.add(UpdateAvailability(availability.id, {
        'specific_date': _toUtc(base).toIso8601String(),
        'start_time': _toUtc(startLocal).toIso8601String(),
        'end_time': _toUtc(endLocal).toIso8601String(),
        'location': controller.text,
      }));
    }
  }
}
