import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/generated/assets.dart';
import 'package:sparring_finder/src/ui/skeletons/calender_screen_skeleton.dart';
import 'package:sparring_finder/src/ui/widgets/app_lottie_loader.dart';
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
  final CalendarController _cal = CalendarController();
  List<Availability> _availabilities = [];
  bool _isLoading = false;
  String? _lottiePath;
  bool _isOperation = false;

  static const _tzParis = 'Romance Standard Time';

  DateTime _toLocal(DateTime t) => t.isUtc ? t.toLocal() : t;

  DateTime _toUtc(DateTime t) => t.isUtc ? t : t.toUtc();

  bool _intervalsOverlap(
          DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) =>
      aStart.isBefore(bEnd) && bStart.isBefore(aEnd);

  bool _overlapsExisting(DateTime start, DateTime end, List<Availability> list,
      [int? ignoreId]) {
    for (final a in list) {
      if (ignoreId != null && a.id == ignoreId) continue;
      if (_intervalsOverlap(
          start, end, _toLocal(a.startTime), _toLocal(a.endTime))) return true;
    }
    return false;
  }

  bool _isEndAfterStart(TimeOfDay s, TimeOfDay e) => e.hour > s.hour;

  TimeOfDay _nextHourAfter(TimeOfDay t) =>
      TimeOfDay(hour: (t.hour + 1) % 24, minute: 0);

  @override
  void initState() {
    super.initState();
    context.read<AvailabilityBloc>().add(const LoadAvailabilities());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ───────────── Calendar + BLoC logic ─────────────
          SafeArea(
            child: BlocConsumer<AvailabilityBloc, AvailabilityState>(
              listener: (context, state) {
                // operation started?
                if (state is AvailabilityLoadInProgress) {
                  setState(() {
                    _lottiePath = Assets.animationsCaledarLoading;
                    _isLoading = true;
                    _isOperation = false;
                  });
                } else if (state is AvailabilityLoadInOperation) {
                  setState(() {
                    _lottiePath = Assets.animationsEvent;
                    _isLoading = false;
                    _isOperation = true;
                  });
                }
                // any success or failure => hide loader
                if (state is AvailabilityOperationSuccess ||
                    state is AvailabilityLoadSuccess ||
                    state is AvailabilityFailure) {
                  setState(() {
                    _lottiePath = null;
                    _isLoading = false;
                    _isOperation = false;
                  });
                }

                if (state is AvailabilityLoadSuccess ||
                    state is AvailabilityOperationSuccess) {
                  final list = state is AvailabilityLoadSuccess
                      ? state.availabilities
                      : (state as AvailabilityOperationSuccess).availabilities;
                  setState(() => _availabilities = list);
                }
                if (state is AvailabilityFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              },
              builder: (context, state) {
                // build availabilities as green appointments
                final availAppts = _availabilities.map((a) {
                  final s = _toLocal(a.startTime);
                  final e = _toLocal(a.endTime);
                  return Appointment(
                    startTime: s,
                    endTime: e,
                    subject: 'Available\n${a.location}',
                    id: a.id,
                    color: AppColors.primary.withOpacity(.5),
                    startTimeZone: _tzParis,
                    endTimeZone: _tzParis,
                  );
                });

                // build sparrings as colored “Booked”
                final sparAppts = _availabilities
                    .expand<Appointment>((a) => a.sparrings.map((s) {
                          final ls = _toLocal(s.startTime);
                          final le = _toLocal(s.endTime);
                          Color c;
                          switch (s.status) {
                            case 'PENDING':
                              c = Colors.yellowAccent.withOpacity(.6);
                              break;
                            case 'CONFIRMED':
                              c = Colors.blue.withOpacity(.6);
                              break;
                            case 'CANCELLED':
                              c = Colors.redAccent.withOpacity(.6);
                              break;
                            default:
                              c = Colors.deepPurpleAccent.withOpacity(.6);
                          }
                          return Appointment(
                            startTime: ls,
                            endTime: le,
                            subject: 'Booked: ${s.status.toLowerCase()}',
                            id: s.id,
                            color: c,
                            startTimeZone: _tzParis,
                            endTimeZone: _tzParis,
                          );
                        }))
                    .toList();

                final allAppts = [...availAppts, ...sparAppts];

                return SfCalendar(
                  timeZone: _tzParis,
                  dataSource: _CalDS(allAppts),
                  view: CalendarView.month,
                  allowedViews: const [
                    CalendarView.day,
                    CalendarView.week,
                    CalendarView.month
                  ],
                  showNavigationArrow: true,
                  showTodayButton: true,
                  allowViewNavigation: true,
                  headerStyle: CalendarHeaderStyle(
                    backgroundColor: AppColors.inputFill,
                    textStyle: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  viewHeaderStyle: const ViewHeaderStyle(
                    dayTextStyle: TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    dateTextStyle: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  monthViewSettings: const MonthViewSettings(
                    showAgenda: true,
                    dayFormat: 'EEE',
                    monthCellStyle: MonthCellStyle(
                      textStyle: TextStyle(color: AppColors.primary),
                      leadingDatesTextStyle: TextStyle(color: AppColors.text),
                      trailingDatesTextStyle: TextStyle(color: AppColors.text),
                    ),
                    agendaStyle: AgendaStyle(
                      dayTextStyle: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      dateTextStyle: TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      appointmentTextStyle: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  timeSlotViewSettings: const TimeSlotViewSettings(
                    timeInterval: Duration(hours: 1),
                    timeTextStyle: TextStyle(color: AppColors.primary),
                  ),
                  todayHighlightColor: AppColors.primary,
                  cellBorderColor: AppColors.border,
                  controller: _cal,
                  onTap: (details) async {
                    final t = details.date;
                    if (t == null) return;

                    if (_cal.view == CalendarView.month) {
                      setState(() {
                        _cal
                          ..view = CalendarView.day
                          ..displayDate = t;
                      });
                      return;
                    }

                    final tapped = details.date;
                    if (tapped == null || tapped.minute != 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Tap only on full‐hour marks.'),
                        backgroundColor: Colors.redAccent,
                      ));
                      return;
                    }
                    final existing = _availabilities.firstWhereOrNull((a) {
                      final s = _toLocal(a.startTime);
                      final e = _toLocal(a.endTime);
                      return tapped.isAtSameMomentAs(s) ||
                          (tapped.isAfter(s) && tapped.isBefore(e));
                    });
                    if (existing != null) {
                      await _showEditOrDeleteDialog(existing);
                    } else {
                      await _showCreateDialog(
                        context,
                        tapped,
                        tapped.add(const Duration(hours: 6)),
                      );
                    }
                  },
                );
              },
            ),
          ),
          // ───────────── Loading Overlay ─────────────
          if(_isLoading)  CalendarScreenSkeleton(),
          if (_isOperation && _lottiePath != null)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                    color: AppColors.background.withValues(alpha: .95),
                    child: AppLottieLoader(
                      size: MediaQuery.of(context).size.width / 2,
                      animationPath: _lottiePath!,
                      repeat: true,
                    )),
              ),
            ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------
  // Dialogs: unchanged from your original
  // --------------------------------------------------------------

  Future<void> _showCreateDialog(
      BuildContext context, DateTime base, DateTime maxEnd) async {
    final bloc = context.read<AvailabilityBloc>();
    final controller =
        TextEditingController(text: '22 Rue Allonvile, Paris, France');
    final hours = List.generate(24, (i) => TimeOfDay(hour: i, minute: 0));
    TimeOfDay startT = TimeOfDay(hour: base.hour, minute: 0);
    TimeOfDay endT = TimeOfDay(hour: (base.hour + 1) % 24, minute: 0);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, setState) {
        return AlertDialog(
          title: const Text('Create Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Start Time:'),
              DropdownButton<TimeOfDay>(
                value: startT,
                isExpanded: true,
                items: hours
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.format(ctx))))
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
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.format(ctx))))
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
                onPressed: () => Navigator.pop(ctx, false),
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
                  Navigator.pop(ctx, true);
                },
                child: const Text('Confirm')),
          ],
        );
      }),
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
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Edit / Delete Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Start Time:'),
              DropdownButton<TimeOfDay>(
                value: startT,
                isExpanded: true,
                items: hours
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.format(ctx))))
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
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.format(ctx))))
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
                onPressed: () => Navigator.pop(ctx, 'delete'),
                child: const Text('Delete')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  final now = DateTime.now();
                  final base = _toLocal(availability.startTime);
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
                  Navigator.pop(ctx, 'save');
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

/// Feeds our flat list of Appointments into SfCalendar
class _CalDS extends CalendarDataSource {
  _CalDS(List<Appointment> source) {
    appointments = source;
  }
}
