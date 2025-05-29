import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../blocs/availability/availability_bloc.dart';
import '../../../blocs/availability/availability_event.dart';
import '../../../blocs/availability/availability_state.dart';

import '../../../blocs/sparring/sparring_bloc.dart';
import '../../../blocs/sparring/sparring_event.dart';
import '../../../blocs/sparring/sparring_state.dart';
import '../../../models/availability/availability_model.dart';
import '../../../models/sparring/sparring_model.dart';

import '../../../utils/jwt.dart';
import '../../theme/app_colors.dart';

class AthleteAvailabilitiesCalenderScreen extends StatefulWidget {
  const AthleteAvailabilitiesCalenderScreen({
    super.key,
    required this.targetUserId,
  });

  final int targetUserId;

  @override
  State<AthleteAvailabilitiesCalenderScreen> createState() =>
      _AthleteAvailabilitiesCalenderScreenState();
}

class _AthleteAvailabilitiesCalenderScreenState
    extends State<AthleteAvailabilitiesCalenderScreen> {
  /// Drives the SfCalendar view / date programmatically
  final CalendarController _cal = CalendarController();

  /// Green “free” fragments (never overlap sparrings)
  List<Appointment> _freeAppts = [];

  /// Blue “my sparring” appointments
  List<Appointment> _myAppts = [];

  /// Red “other people’s sparring” appointments
  List<Appointment> _otherAppts = [];

  /// Logged-in user id (decoded from JWT once at startup)
  int? _currentUserId;

  /*───────────────────────────
   * INITIALISATION
   *───────────────────────────*/

  @override
  void initState() {
    super.initState();
    _bootstrap(); // → async method that loads user id & fetches data
  }

  /// 1. Decode JWT to know current user.
  /// 2. Kick off both AvailabilityBloc & SparringBloc fetches.
  Future<void> _bootstrap() async {
    final decoded = await JwtStorageHelper.getDecodedAccessToken();
    _currentUserId = decoded['id'] as int?;

    // Ahmed’s availabilities
    context
        .read<AvailabilityBloc>()
        .add(LoadAvailabilitiesByTargetUserId(widget.targetUserId));

    // All sparrings relevant to current user (backend filter)
    context
        .read<SparringBloc>()
        .add(LoadSparringsByUserIdAndPartnerId(widget.targetUserId));
  }

  /*───────────────────────────
   * MAPPING HELPERS
   *───────────────────────────*/

  /// Convert raw Availability rows into *overlapping* “proto” appointments.
  /// We later carve out the booked parts, so colour is omitted here.
  List<Appointment> _rawAvail(List<Availability> src) {
    return src
        .map(
          (a) => Appointment(
            startTime: DateTime(
              a.specificDate.year,
              a.specificDate.month,
              a.specificDate.day,
              a.startTime.hour,
              a.startTime.minute,
            ),
            endTime: DateTime(
              a.specificDate.year,
              a.specificDate.month,
              a.specificDate.day,
              a.endTime.hour,
              a.endTime.minute,
            ),
            subject: 'Free',
            id: a.id,
            // availability id for backend reference
            location: a.location,
          ),
        )
        .toList();
  }

  /// Convert Sparring rows to appointments, colouring according to ownership.
  List<Appointment> _sparToAppt(List<Sparring> src) {
    return src.map((s) {
      final mine = _currentUserId != null && s.requesterId == _currentUserId;


      String? text = "";
      if (s.cancelledByUserId == _currentUserId) {
        text = "by me";
      }

      return Appointment(
        startTime: s.startTime.toLocal(),
        endTime: s.endTime.toLocal(),
        subject: mine
            ? 'My SP : ${s.status.toLowerCase()} $text'
            : 'Booked ${s.status}',
        color: mine
            ? (s.status == "PENDING"
                ? Colors.yellowAccent.withValues(alpha: .3)
                : s.status == "CANCELLED"
                    ? Colors.redAccent.withValues(alpha: .3)
                    : s.status == "CONFIRMED"
                        ? Colors.blue.withValues(alpha: .3)
                        : Colors.deepPurpleAccent)
            : Colors.deepPurpleAccent,
        id: s.id,
        notes: mine ? 'mine' : 'other',
        // lightweight tag for hit-testing
        location: s.location,
      );
    }).toList();
  }

  /// Split each availability into “free fragments” by subtracting
  /// every overlapping sparring. Result: green blocks never overlap blue/red.
  List<Appointment> _splitFree(
      List<Appointment> rawAvail, List<Appointment> allSpars) {
    final free = <Appointment>[];

    for (final av in rawAvail) {
      // Sparrings that overlap this availability (sorted by start)
      final overlaps = allSpars
          .where((s) =>
              s.startTime.isBefore(av.endTime) &&
              s.endTime.isAfter(av.startTime))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      DateTime cursor = av.startTime; // walk along the availability

      for (final sp in overlaps) {
        // Gap BEFORE this sparring → still free
        if (cursor.isBefore(sp.startTime)) {
          free.add(_frag(av, cursor, sp.startTime));
        }
        // Move cursor past this booking
        cursor = sp.endTime.isAfter(cursor) ? sp.endTime : cursor;
      }

      // Tail part AFTER last booking
      if (cursor.isBefore(av.endTime)) {
        free.add(_frag(av, cursor, av.endTime));
      }
    }

    return free;
  }

  /// Helper to build a single green free-fragment
  Appointment _frag(Appointment proto, DateTime st, DateTime en) => Appointment(
        startTime: st,
        endTime: en,
        subject: 'Free',
        color: Colors.greenAccent.withOpacity(.35),
        id: proto.id,
        location: proto.location,
      );

  /*───────────────────────────
   * MERGE & REFRESH
   *───────────────────────────*/

  // Keep the latest raw lists so we can recompute layers every time
  List<Availability> _latestAvail = [];
  List<Sparring> _latestSpars = [];

  /// Called whenever either bloc emits new data.
  /// Re-computes the three layers: free, my, other.
  void _refresh({List<Availability>? avail, List<Sparring>? spars}) {
    if (avail != null) _latestAvail = avail;
    if (spars != null) _latestSpars = spars;

    final rawAvail = _rawAvail(_latestAvail);
    final sparAppts = _sparToAppt(_latestSpars);

    _myAppts = sparAppts.where((a) => a.notes == 'mine').toList();
    _otherAppts = sparAppts.where((a) => a.notes == 'other').toList();
    _freeAppts = _splitFree(rawAvail, sparAppts);

    setState(() {}); // trigger rebuild
  }

  /*───────────────────────────
   * UI BUILD
   *───────────────────────────*/

  @override
  Widget build(BuildContext context) {
    // Stacking order = free → my → others  (green below blue below red)
    final combined = [..._freeAppts, ..._myAppts, ..._otherAppts];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // Listen to availability changes
            BlocListener<AvailabilityBloc, AvailabilityState>(
              listener: (_, st) {
                if (st is AvailabilityLoadSuccess) {
                  _refresh(avail: st.availabilities);
                }
                if (st is AvailabilityFailure) {}
                if (st is AvailabilityLoadInProgress) {
                }
              },
            ),
            // Listen to sparring changes
            BlocListener<SparringBloc, SparringState>(
              listener: (_, st) {
                if (st is SparringLoadSuccess) {
                  _refresh(spars: st.sparrings);
                } else if (st is SparringOperationSuccess) {
                  // After create / update / delete → reload list
                  context.read<SparringBloc>().add(LoadSparrings());
                }
              },
            ),
          ],
          child: SfCalendar(
            controller: _cal,
            dataSource: _CalDS(combined),
            view: CalendarView.month,
            onTap: _handleTap,
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
                  color: Colors.orange, // Event text
                ),
              ),
            ),
            allowedViews: [
              CalendarView.day,
              CalendarView.month,
              CalendarView.week
            ],
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
          ),
        ),
      ),
    );
  }

  /*───────────────────────────
   * TAP HANDLER
   *───────────────────────────*/

  Future<void> _handleTap(CalendarTapDetails d) async {
    final t = d.date;

    if (t == null) return;

    /* If Month view → drill down to Week view of that date */
    if (_cal.view == CalendarView.month) {
      setState(() {
        _cal
          ..view = CalendarView.day
          ..displayDate = t;
      });
      return;
    }

    /* Identify what was tapped (blue > red > green) */
    final my = _myAppts.firstWhereOrNull((a) => _hit(a, t));
    final other = _otherAppts.firstWhereOrNull((a) => _hit(a, t));
    final free = _freeAppts.firstWhereOrNull((a) => _hit(a, t));

    /* 2a – delete own booking */
    if (my != null) {
      await _editOrDelete(
        my,
      );
      return;
    }

    /* 2b – someone else already booked */
    if (other != null) {
      _toast('Slot already booked', Colors.redAccent);
      return;
    }

    /* 2c – inside a free fragment → create new sparring */
    if (free != null) {
      final now = DateTime.now();
      if (t.isBefore(now)) {
        _toast('Cannot book in the past', Colors.redAccent);
        return;
      }
      await _create(
        t,
        free.startTime,
        free.endTime,
        free.id as int, /* availability id */
      );
      return;
    }

    /* 2d – any other tap */
    _toast('Tap inside a free slot', AppColors.primary);
  }

  /// Quick hit-test: tap inside appointment start/end (1-minute tolerance)
  bool _hit(Appointment a, DateTime p) =>
      p.isAfter(a.startTime.subtract(const Duration(minutes: 1))) &&
      p.isBefore(a.endTime);

  /// Snack-bar helper
  void _toast(String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m), backgroundColor: c),
      );

  /// Create-reservation dialog (blue).
  Future<void> _create(
      DateTime base, DateTime minStart, DateTime maxEnd, int availId) async {
    final bloc = context.read<SparringBloc>();

    // Generate whole-hour choices (could switch to half-hour)
    final hours = List.generate(24, (h) => TimeOfDay(hour: h, minute: 0));
    // final newStartHour = hours.where((t) => )

    TimeOfDay startT = TimeOfDay(hour: base.hour, minute: 0);
    TimeOfDay endT = _next(startT);
    final ctrl = TextEditingController(text: 'Gym XYZ');

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('Reserve sparring'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            // ── Start time ──────────────────────────
            const Text('Start:'),
            DropdownButton<TimeOfDay>(
              value: startT,
              isExpanded: true,
              items: hours
                  .where((t) =>
                      DateTime(base.year, base.month, base.day, t.hour + 1)
                          .isAfter(base))
                  .where((t) =>
                      DateTime(base.year, base.month, base.day, t.hour)
                          .isBefore(maxEnd))
                  .map((t) =>
                      DropdownMenuItem(value: t, child: Text(t.format(ctx))))
                  .toList(),
              onChanged: (t) {
                if (t != null) {
                  set(() {
                    startT = t;
                    if (!_endAfter(startT, endT)) endT = _next(startT);
                  });
                }
              },
            ),
            // ── End time ────────────────────────────
            const Text('End:'),
            DropdownButton<TimeOfDay>(
              value: endT,
              isExpanded: true,
              items: hours
                  .where((t) =>
                      _endAfter(startT, t) &&
                      DateTime(base.year, base.month, base.day, t.hour)
                          .isBefore(maxEnd.add(const Duration(minutes: 1))))
                  .map((t) =>
                      DropdownMenuItem(value: t, child: Text(t.format(ctx))))
                  .toList(),
              onChanged: (t) => set(() => endT = t!),
            ),
            // ── Location field ───────────────────────
            TextField(
              controller: ctrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
          ]),
          // ── Actions ───────────────────────────────
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Confirm')),
          ],
        ),
      ),
    );

    // User cancelled
    if (ok != true) return;

    // Build final UTC timestamps
    final start = DateTime(base.year, base.month, base.day, startT.hour);
    final end = DateTime(base.year, base.month, base.day, endT.hour);

    bloc.add(CreateSparring({
      'availability_id': availId,
      'partner_id': widget.targetUserId,
      'scheduled_date': start.toUtc().toIso8601String(),
      'start_time': start.toUtc().toIso8601String(),
      'end_time': end.toUtc().toIso8601String(),
      'location': ctrl.text,
    }, widget.targetUserId));
  }

  /// Delete dialog.
  Future<void> _editOrDelete(Appointment appt) async {
    final bloc = context.read<SparringBloc>();
    final String formattedStart =
    TimeOfDay.fromDateTime(appt.startTime).format(context);
    final String formattedEnd =
    TimeOfDay.fromDateTime(appt.endTime).format(context);

    final act = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Sparring?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start Time: $formattedStart'),
            const SizedBox(height: 8),
            Text('End Time: $formattedEnd'),
            const SizedBox(height: 16),
            const Text('Are you sure you want to cancel this sparring session?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'delete'),
            child: const Text('Cancel Sparring'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Close'),
          ),
        ],
      ),
    );

    if (act == 'delete') {
      bloc.add(CancelSparring(
        id: appt.id as int,
        data: {'reason': 'User cancelled'},
        partnerId: widget.targetUserId,
      ));
    }
  }



  /*───────────────────────────
   * UTILITY HELPERS
   *───────────────────────────*/

  /// True when *end* is after *start* (hour + minute aware)
  bool _endAfter(TimeOfDay s, TimeOfDay e) =>
      e.hour > s.hour || (e.hour == s.hour && e.minute > s.minute);

  /// Next whole-hour after given TimeOfDay
  TimeOfDay _next(TimeOfDay t) => TimeOfDay(hour: (t.hour + 1) % 24, minute: 0);
}

/*───────────────────────────────────────────────────────────────
  CUSTOM DATASOURCE for SfCalendar
───────────────────────────────────────────────────────────────*/

class _CalDS extends CalendarDataSource {
  _CalDS(List<Appointment> list) {
    appointments = list;
  }
}
