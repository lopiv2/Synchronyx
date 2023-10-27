import 'dart:io';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:synchronyx/models/event.dart';
import 'package:synchronyx/utilities/generic_functions.dart';

class CustomCalendarCell<T extends Object?> extends StatelessWidget {
  /// Date of current cell.
  final DateTime date;

  /// List of events on for current date.
  final List<CalendarEventData<T>> events;

  /// Metadata, usually image file for current event.
  final Event eventsMetadata;

  /// defines date string for current cell.
  final StringProvider? dateStringBuilder;

  /// Defines if cell should be highlighted or not.
  /// If true it will display date title in a circle.
  final bool shouldHighlight;

  /// If true, the font of days of the month will be bold
  final bool boldMonthDays;

  /// Defines background color of cell.
  final Color backgroundColor;

  /// Defines highlight color.
  final Color highlightColor;

  /// Color for event tile.
  final Color tileColor;

  /// Called when user taps on any event tile.
  final TileTapCallback<T>? onTileTap;

  /// defines that [date] is in current month or not.
  final bool isInMonth;

  /// defines radius of highlighted date.
  final double highlightRadius;

  /// color of cell title
  final Color titleColor;

  /// color of highlighted cell title
  final Color highlightedTitleColor;

  const CustomCalendarCell({
    Key? key,
    required this.date,
    required this.events,
    required this.eventsMetadata,
    this.isInMonth = false,
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    this.onTileTap,
    this.tileColor = Colors.blue,
    this.highlightRadius = 11,
    this.titleColor = Colors.black,
    this.highlightedTitleColor = Colors.white,
    this.dateStringBuilder,
    this.boldMonthDays = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (eventsMetadata.image != null && eventsMetadata.image != '') {
      return FutureBuilder<Color>(
          future: detectDominantColor(eventsMetadata.image ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Mientras se carga el color
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('Cargando color...');
            } else {
              final backgroundColorText = snapshot.data!;
              final textColor = determineTextColor(backgroundColorText);
              return Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    CircleAvatar(
                      radius: highlightRadius,
                      backgroundColor:
                          shouldHighlight ? highlightColor : Colors.transparent,
                      child: Text(
                        dateStringBuilder?.call(date) ?? "${date.day}",
                        style: TextStyle(
                          fontWeight: boldMonthDays && isInMonth
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: shouldHighlight
                              ? highlightedTitleColor
                              : isInMonth
                                  ? titleColor.withOpacity(1)
                                  : titleColor.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (events.isNotEmpty)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 1.0),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                events.length,
                                (index) => GestureDetector(
                                  onTap: () => onTileTap?.call(
                                      events[index], events[index].date),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: events[index].color,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 3.0),
                                      padding: const EdgeInsets.all(2.0),
                                      alignment: Alignment.center,
                                      child: Container(
                                        //height:100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(File(
                                                eventsMetadata.image ?? '')),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Tooltip(
                                                message: events[index].title,
                                                child: Text(
                                                  events[index].title,
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 5,
                                                  style: events[0].titleStyle ??
                                                      TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: textColor,
                                                        fontSize: 12,
                                                      ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
          });
    } else {
      return Container(
        color: backgroundColor,
        child: Column(
          children: [
            const SizedBox(
              height: 5.0,
            ),
            CircleAvatar(
              radius: highlightRadius,
              backgroundColor:
                  shouldHighlight ? highlightColor : Colors.transparent,
              child: Text(
                dateStringBuilder?.call(date) ?? "${date.day}",
                style: TextStyle(
                  fontWeight: boldMonthDays && isInMonth
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: shouldHighlight
                      ? highlightedTitleColor
                      : isInMonth
                          ? titleColor.withOpacity(1)
                          : titleColor.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ),
            if (events.isNotEmpty)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        events.length,
                        (index) => GestureDetector(
                          onTap: () => onTileTap?.call(
                              events[index], events[index].date),
                          child: Container(
                              decoration: BoxDecoration(
                                color: events[index].color,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 3.0),
                              padding: const EdgeInsets.all(2.0),
                              alignment: Alignment.center,
                              child: Container(
                                //height:100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(
                                        eventsMetadata.image ??
                                            '')), // Ruta de tu archivo
                                    fit: BoxFit
                                        .cover, // Ajusta la imagen al tamaño del contenedor
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        events[index].title,
                                        overflow: TextOverflow.clip,
                                        maxLines: 4,
                                        style: events[0].titleStyle ??
                                            TextStyle(
                                              color: events[index].color.accent,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }
}
