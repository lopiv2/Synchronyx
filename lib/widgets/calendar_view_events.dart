import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synchronyx/widgets/custom_calendar_cell.dart';

class CalendarViewEvents extends StatefulWidget {
  const CalendarViewEvents({super.key});

  @override
  State<CalendarViewEvents> createState() => _CalendarViewEventsState();
}

class _CalendarViewEventsState extends State<CalendarViewEvents> {
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Carga tus eventos aquí
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final languageCode = currentLocale.languageCode;
    final countryCode = currentLocale.countryCode;
    final localeCode =
        '$languageCode${countryCode != null ? '_$countryCode' : ''}';
    final EventController controller = EventController();
    final event = CalendarEventData(
      date: DateTime(2023, 9, 07),
      title: 'Duplicate',
    );
    controller.add(event);

    return MonthView(
      pageTransitionCurve: Curves.easeInCubic,
      controller: controller,
      startDay: WeekDays.monday,
      headerStringBuilder: (date, {secondaryDate}) {
        // Build the string for the header here
        final year = DateFormat.y().format(date);
        return '${getNameMonthLocated(date, localeCode)} $year'; // Returns the formatted string
      },
      weekDayStringBuilder: (index) {
        return getDayOfWeekFromIndex(index, localeCode);
      },
      cellBuilder: (date, events, isToday, isInMonth) {
        return CustomCalendarCell(
          isInMonth: isInMonth,
          boldMonthDays: true,
          highlightRadius: 15,
          shouldHighlight: isToday,
          titleColor: isInMonth ? Color.fromARGB(255, 0, 0, 0) : Colors.white,
          date: date,
          events: events,
          backgroundColor:
              isInMonth ? Color.fromARGB(255, 76, 175, 79) : Colors.black12,
        );
      },
    );
  }

  String getDayOfWeekFromIndex(int index, String localeCode) {
    final List<String> daysOfWeek =
        DateFormat('EEE', localeCode).dateSymbols.SHORTWEEKDAYS;
    final int adjustedIndex =
        (index + 1) % 7; // Adjust index to start on Monday
    if (adjustedIndex >= 0 && adjustedIndex < daysOfWeek.length) {
      final String day = daysOfWeek[adjustedIndex];
      if (day.isNotEmpty) {
        return day[0].toUpperCase() + day.substring(1).toLowerCase();
      }
    }
    return '';
  }

  String getNameMonthLocated(DateTime fecha, String localeCode) {
    final formato = DateFormat.MMMM(localeCode);
    final nombreMes = formato.format(fecha);
    return nombreMes[0].toUpperCase() + nombreMes.substring(1);
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _loadEvents() {
    // Aquí debes cargar tus eventos en el mapa _events
    // Por ejemplo, agrega un evento el 2023-09-20
    _events[DateTime(2023, 9, 20)] = ['Evento 1', 'Evento 2'];

    // Debes cargar tus eventos de acuerdo a tus datos
  }
}
