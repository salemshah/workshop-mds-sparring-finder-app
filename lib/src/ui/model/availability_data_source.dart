import 'dart:convert';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import '../../models/availability/availability_model.dart';
import '../theme/app_colors.dart';

class AvailabilityDataSource extends CalendarDataSource {
  AvailabilityDataSource({
    required List<Availability> availabilities,
    required this.currentUserId,
  }) {
    appointments = <Appointment>[];

    for (final a in availabilities) {
      appointments!.add(Appointment(
        id: 'avail_${a.id}',
        startTime: a.startTime,
        endTime: a.endTime,
        subject: 'Available',
        color: AppColors.primary.withOpacity(0.2),
        // ← JSON-encode instead of passing a Map directly
        notes: jsonEncode({
          'type': 'availability',
          'availabilityId': a.id,
        }),
      ));

      for (final s in a.sparrings) {
        final isMine = s.requesterId == currentUserId;
        appointments!.add(Appointment(
          id: 'spar_${s.id}',
          startTime: s.startTime,
          endTime: s.endTime,
          subject: s.partnerProfile?.firstName ?? 'Sparring',
          color: isMine ? Colors.greenAccent : Colors.redAccent,
          notes: jsonEncode({
            'type': 'sparring',
            'sparringId': s.id,
            'availabilityId': a.id,
            'requesterId': s.requesterId,
          }),
        ));
      }
    }
  }

  final int currentUserId;
}
