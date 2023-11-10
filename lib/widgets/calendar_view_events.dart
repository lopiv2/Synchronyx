import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/models/event.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/utilities/generic_database_functions.dart';
import 'package:lioncade/utilities/generic_functions.dart';
import 'package:lioncade/widgets/custom_calendar_cell.dart';

class CalendarViewEvents extends StatelessWidget {
  final EventController controller;
  const CalendarViewEvents({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final currentLocale = Localizations.localeOf(context);
    final appState = Provider.of<AppState>(context);
    final languageCode = currentLocale.languageCode;
    final countryCode = currentLocale.countryCode;
    final localeCode =
        '$languageCode${countryCode != null ? '_$countryCode' : ''}';
    return FutureBuilder<List<Event>>(
        future: getAllEvents(),
        builder: (context, eventsSnapshot) {
          if (eventsSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (eventsSnapshot.hasError) {
            return Text('Error: ${eventsSnapshot.error}');
          } else if (!eventsSnapshot.hasData) {
            return const Text('Cargando contenedores...');
          } else {
            List<Event> eventsList = eventsSnapshot.data!;
            appState.events.clear();
            appState.addAllEvents(eventsList);
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
                final eventMetadata = getEventMetadata(eventsList, date);
                final eventsForDate = appState.events
                    .where((event) =>
                        event.date.year == date.year &&
                        event.date.month == date.month &&
                        event.date.day == date.day)
                    .toList();
                return CustomCalendarCell(
                  eventsMetadata: eventMetadata,
                  isInMonth: isInMonth,
                  boldMonthDays: true,
                  highlightRadius: 15,
                  shouldHighlight: isToday,
                  titleColor: isInMonth
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : Colors.white,
                  date: date,
                  events: eventsForDate,
                  tileColor: Colors.blue,
                  backgroundColor: isInMonth
                      ? hexToColorWithAlpha(appState.themeApplied.backgroundStartColor,200)
                      : Colors.black12,
                );
              },
            );
          }
        });
  }

  Event getEventMetadata(List<Event> eventsList, DateTime date) {
    for (final event in eventsList) {
      if (event.releaseDate == date) {
        return event;
      }
    }
    return Event(
        releaseDate: DateTime.now(),
        dismissed: 0,
        name: '',
        game: '',
        image: '');
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
}
