import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../blocs/availability/availability_bloc.dart';
import '../../../blocs/availability/availability_event.dart';
import '../../../blocs/availability/availability_state.dart';
import '../../../models/availability/availability_model.dart';

import '../../../blocs/sparring/sparring_bloc.dart';
import '../../../blocs/sparring/sparring_event.dart';
import '../../../blocs/sparring/sparring_state.dart';
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
  final CalendarController _cal = CalendarController();

  List<Appointment> _freeAppts = [];
  List<Appointment> _myAppts = [];
  List<Appointment> _otherAppts = [];

  List<Availability> _latestAvail = [];
  List<Sparring> _latestSpars = [];

  int? _currentUserId;

  /// The Syncfusion “time zone region” for Paris
  static const _tzParis = 'Romance Standard Time';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final decoded = await JwtStorageHelper.getDecodedAccessToken();
    _currentUserId = decoded['id'] as int?;

    context
        .read<AvailabilityBloc>()
        .add(LoadAvailabilitiesByTargetUserId(widget.targetUserId));

    context
        .read<SparringBloc>()
        .add(LoadSparringsByUserIdAndPartnerId(widget.targetUserId));
  }

  DateTime _toLocal(DateTime t) => t.isUtc ? t.toLocal() : t;
  DateTime _toUtc(DateTime t)   => t.isUtc ? t : t.toUtc();

  List<Appointment> _rawAvail(List<Availability> src) {
    return src.map((a) {
      final ls = _toLocal(a.startTime);
      final le = _toLocal(a.endTime);
      return Appointment(
        startTime:     ls,
        endTime:       le,
        subject:       'Free',
        id:            a.id,
        location:      a.location,
        startTimeZone: _tzParis,
        endTimeZone:   _tzParis,
      );
    }).toList();
  }

  List<Appointment> _sparToAppt(List<Sparring> src) {
    return src.map((s) {
      final mine = s.requesterId == _currentUserId;
      final ls = _toLocal(s.startTime);
      final le = _toLocal(s.endTime);
      final txt = mine
          ? 'My SP : ${s.status.toLowerCase()}'
          : 'Booked ${s.status.toLowerCase()}';
      return Appointment(
        startTime:     ls,
        endTime:       le,
        subject:       txt,
        id:            s.id,
        notes:         mine ? 'mine' : 'other',
        location:      s.location,
        color:         mine
            ? (s.status == "PENDING"
            ? Colors.yellowAccent.withOpacity(.3)
            : s.status == "CANCELLED"
            ? Colors.redAccent.withOpacity(.3)
            : s.status == "CONFIRMED"
            ? Colors.blue.withOpacity(.3)
            : Colors.deepPurpleAccent)
            : Colors.deepPurpleAccent,
        startTimeZone: _tzParis,
        endTimeZone:   _tzParis,
      );
    }).toList();
  }

  List<Appointment> _splitFree(
      List<Appointment> raw, List<Appointment> spars) {
    final free = <Appointment>[];
    for (final av in raw) {
      final overlaps = spars
          .where((s) =>
      s.startTime.isBefore(av.endTime) &&
          s.endTime.isAfter(av.startTime))
          .toList()
        ..sort((a,b)=>a.startTime.compareTo(b.startTime));

      DateTime cursor = av.startTime;
      for (final s in overlaps) {
        if (cursor.isBefore(s.startTime)) {
          free.add(_frag(av, cursor, s.startTime));
        }
        cursor = s.endTime.isAfter(cursor) ? s.endTime : cursor;
      }
      if (cursor.isBefore(av.endTime)) {
        free.add(_frag(av, cursor, av.endTime));
      }
    }
    return free;
  }

  Appointment _frag(Appointment proto, DateTime st, DateTime en) =>
      Appointment(
        startTime:     st,
        endTime:       en,
        subject:       'Free',
        id:            proto.id,
        location:      proto.location,
        color:         Colors.greenAccent.withOpacity(.35),
        startTimeZone: _tzParis,
        endTimeZone:   _tzParis,
      );

  void _refresh({List<Availability>? avail, List<Sparring>? spars}) {
    if (avail != null) _latestAvail = avail;
    if (spars != null) _latestSpars = spars;

    final raw = _rawAvail(_latestAvail);
    final spar = _sparToAppt(_latestSpars);

    _myAppts = spar.where((a) => a.notes == 'mine').toList();
    _otherAppts = spar.where((a) => a.notes == 'other').toList();
    _freeAppts = _splitFree(raw, spar);

    setState(() {});
  }

  bool _hit(Appointment a, DateTime t) =>
      t.isAfter(a.startTime.subtract(const Duration(minutes:1))) &&
          t.isBefore(a.endTime);

  void _toast(String m, Color c) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(m), backgroundColor: c));

  @override
  Widget build(BuildContext context) {
    final combined = [..._freeAppts, ..._myAppts, ..._otherAppts];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<AvailabilityBloc, AvailabilityState>(
              listener: (_, st) {
                if (st is AvailabilityLoadSuccess) {
                  _refresh(avail: st.availabilities);
                }
              },
            ),
            BlocListener<SparringBloc, SparringState>(
              listener: (_, st) {
                if (st is SparringLoadSuccess) {
                  _refresh(spars: st.sparrings);
                } else if (st is SparringOperationSuccess) {
                  // reload to get the up-to-date list
                  context.read<SparringBloc>().add(
                      LoadSparringsByUserIdAndPartnerId(widget.targetUserId));
                }
              },
            ),
          ],
          child: SfCalendar(
            controller: _cal,
            dataSource: _CalDS(combined),
            view: CalendarView.month,
            timeZone: _tzParis,  // calendar-wide timezone :contentReference[oaicite:1]{index=1}
            onTap: _handleTap,
            showNavigationArrow: true,
            showTodayButton: true,
            allowViewNavigation: true,
            todayHighlightColor: AppColors.primary,
            cellBorderColor: AppColors.border,
            timeSlotViewSettings: const TimeSlotViewSettings(
              endHour: 24,
              startHour: 0,
              timeFormat: 'HH:mm',
              timeInterval: Duration(hours: 1),
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
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(CalendarTapDetails d) async {
    final t = d.date;
    if (t == null) return;

    if (_cal.view == CalendarView.month) {
      setState(() {
        _cal
          ..view = CalendarView.day
          ..displayDate = t;
      });
      return;
    }

    final mine  = _myAppts.firstWhereOrNull((a) => _hit(a, t));
    final other = _otherAppts.firstWhereOrNull((a) => _hit(a, t));
    final free  = _freeAppts.firstWhereOrNull((a) => _hit(a, t));

    if (mine != null) {
      await _editOrDelete(mine);
    } else if (other != null) {
      _toast('Slot already booked', Colors.redAccent);
    } else if (free != null) {
      if (t.isBefore(DateTime.now())) {
        _toast('Cannot book in the past', Colors.redAccent);
      } else {
        await _create(t, free.startTime, free.endTime, free.id as int);
      }
    } else {
      _toast('Tap inside a free slot', AppColors.primary);
    }
  }

  Future<void> _create(
      DateTime base, DateTime minStart, DateTime maxEnd, int availId) async {
    final bloc = context.read<SparringBloc>();
    final hours = List.generate(24, (h) => TimeOfDay(hour: h, minute: 0));
    TimeOfDay startT = TimeOfDay(hour: base.hour, minute: 0);
    TimeOfDay endT   = TimeOfDay(hour: (base.hour + 1) % 24, minute: 0);
    final ctrl = TextEditingController(text: 'Gym XYZ');

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('Reserve sparring'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Start:'),
            DropdownButton<TimeOfDay>(
              value: startT,
              isExpanded: true,
              items: hours
                  .where((t) =>
                  DateTime(base.year, base.month, base.day, t.hour + 1)
                      .isAfter(minStart))
                  .where((t) =>
                  DateTime(base.year, base.month, base.day, t.hour)
                      .isBefore(maxEnd))
                  .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t.format(ctx)),
              ))
                  .toList(),
              onChanged: (t) {
                if (t != null) {
                  set(() {
                    startT = t;
                    if (!(_endAfter(startT, endT))) {
                      endT = TimeOfDay(hour:(startT.hour+1)%24, minute:0);
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            const Text('End:'),
            DropdownButton<TimeOfDay>(
              value: endT,
              isExpanded: true,
              items: hours
                  .where((t) =>
              _endAfter(startT, t) &&
                  DateTime(base.year, base.month, base.day, t.hour)
                      .isBefore(maxEnd.add(const Duration(minutes:1))))
                  .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t.format(ctx)),
              ))
                  .toList(),
              onChanged: (t) { if (t != null) set(() => endT = t); },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
          ]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;

    final startLocal = DateTime(
        base.year, base.month, base.day, startT.hour);
    final endLocal   = DateTime(
        base.year, base.month, base.day, endT.hour);

    // ■ Overlap guard against existing sparrings
    final overlap = _latestSpars.any((s) {
      final s1 = _toLocal(s.startTime);
      final s2 = _toLocal(s.endTime);
      return startLocal.isBefore(s2) && s1.isBefore(endLocal);
    });
    if (overlap) {
      _toast('Overlaps an existing sparring', Colors.redAccent);
      return;
    }

    bloc.add(CreateSparring({
      'availability_id': availId,
      'partner_id': widget.targetUserId,
      'scheduled_date': _toUtc(startLocal).toIso8601String(),
      'start_time':     _toUtc(startLocal).toIso8601String(),
      'end_time':       _toUtc(endLocal).toIso8601String(),
      'location':       ctrl.text,
    }, widget.targetUserId));
  }

  Future<void> _editOrDelete(Appointment appt) async {
    final bloc = context.read<SparringBloc>();
    final f1 = TimeOfDay.fromDateTime(appt.startTime).format(context);
    final f2 = TimeOfDay.fromDateTime(appt.endTime).format(context);

    final choice = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Sparring?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Start: $f1'),
            const SizedBox(height: 8),
            Text('End:   $f2'),
            const SizedBox(height: 16),
            const Text('Are you sure you want to cancel?'),
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
    if (choice == 'delete') {
      bloc.add(CancelSparring(
        id: appt.id as int,
        data: {'reason': 'User cancelled'},
        partnerId: widget.targetUserId,
      ));
    }
  }

  bool _endAfter(TimeOfDay a, TimeOfDay b) =>
      b.hour > a.hour || (b.hour == a.hour && b.minute > a.minute);
}

class _CalDS extends CalendarDataSource {
  _CalDS(List<Appointment> source) {
    appointments = source;
  }
}