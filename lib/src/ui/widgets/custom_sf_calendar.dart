import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../theme/app_colors.dart';

/// A drop-in Syncfusion calendar with your app’s default styling,
/// but customizable data source, view, allowedViews, and tap handler.
class CustomSfCalendar extends StatelessWidget {
  /// The appointments / events to show.
  final CalendarDataSource dataSource;

  /// The initial view (day, week, month…).
  final CalendarView initialView;

  /// Which views the user may switch to.
  final List<CalendarView> allowedViews;

  /// Called when the user taps a cell or appointment.
  final void Function(CalendarTapDetails details)? onTap;

  const CustomSfCalendar({
    super.key,
    required this.dataSource,
    this.initialView = CalendarView.week,
    this.allowedViews = const [
      CalendarView.day,
      CalendarView.week,
      CalendarView.month
    ],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      dataSource: dataSource,
      view: initialView,
      allowedViews: allowedViews,
      showNavigationArrow: true,
      showTodayButton: true,
      allowViewNavigation: true,
      showDatePickerButton: true,

      // theming
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
        timeInterval: Duration(minutes: 60),
        timeTextStyle: TextStyle(color: AppColors.primary),
      ),
      headerStyle: const CalendarHeaderStyle(
        backgroundColor: AppColors.inputFill,
        textStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      todayHighlightColor: AppColors.primary,
      cellBorderColor: AppColors.border,

      onTap: onTap,
    );
  }
}
