import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/models/event.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/utilities/generic_database_functions.dart';

class NotificationButtonWidget extends StatefulWidget {
  final List<Event> eventsList;
  final AppState appState;
  final Function onEventDismissedCallback;

  const NotificationButtonWidget({
    super.key,
    required this.eventsList,
    required this.appState,
    required this.onEventDismissedCallback,
  });

  @override
  State<NotificationButtonWidget> createState() =>
      _NotificationButtonWidgetState();
}

class _NotificationButtonWidgetState extends State<NotificationButtonWidget>
    with SingleTickerProviderStateMixin {
  int notificationCount = 0; // Number of notifications
  late List<Event> notifyEvents;
  bool _isRotating = false;
  GlobalKey actionKey = GlobalKey();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    notifyEvents = getEventsWithinNextXHours(
        widget.eventsList, widget.appState.optionsResponse.hoursAdvanceNotice);
    notificationCount = notifyEvents.length;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = Tween(begin: -0.7, end: 0.7).animate(_controller);

    if (notificationCount > 0) {
      // Iniciar la rotación del péndulo si hay notificaciones
      _startRotation();
    }
  }

  void _startRotation() async {
    if (_isRotating) return;

    _isRotating = true;
    _controller.repeat(reverse: true);

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      _controller.stop();
      setState(() {
        _isRotating = false;
      });
      await Future.delayed(const Duration(seconds: 1));
      _startRotation();
    }
  }

  void _handleEventDismissed() {
    setState(() {
      notifyEvents = getEventsWithinNextXHours(
        widget.eventsList,
        widget.appState.optionsResponse.hoursAdvanceNotice,
      );
      notificationCount = notifyEvents.length;
    });
    widget.onEventDismissedCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          IconButton(
            onPressed: () {
              showPopover(
                context: context,
                barrierColor: Colors.transparent,
                bodyBuilder: (context) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final notifyEvents = getEventsWithinNextXHours(
                        widget.eventsList,
                        widget.appState.optionsResponse.hoursAdvanceNotice,
                      );
                      final totalHeight = notifyEvents.length *
                          50.0; // Altura estimada de cada elemento

                      return ListItems(
                        notifyEvents: notifyEvents,
                        totalHeight: totalHeight,
                        closePopover: () {
                          Navigator.of(context).pop(); // Cierra el Popover
                        },
                        onEventDismissed: _handleEventDismissed,
                      );
                    },
                  );
                },
                direction: PopoverDirection.bottom,
                backgroundColor: Colors.green,
                width: 300,
                arrowHeight: 15,
                arrowWidth: 30,
              );
            },
            icon: notificationCount > 0
                ? AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value,
                        child: Icon(_isRotating
                            ? Icons.notifications_active
                            : Icons.notifications),
                      );
                    },
                  )
                : const Icon(Icons.notifications),
            color: Colors.white,
          ),
          if (notificationCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  notificationCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ListItems extends StatefulWidget {
  final List<Event> notifyEvents;
  final double totalHeight;
  final Function closePopover;
  final Function onEventDismissed;

  const ListItems({
    Key? key,
    required this.notifyEvents,
    required this.totalHeight,
    required this.closePopover,
    required this.onEventDismissed,
  }) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  List<bool> itemDismissed = [];

  @override
  void initState() {
    super.initState();
    itemDismissed = List.filled(widget.notifyEvents.length, false);
  }

  @override
  Widget build(BuildContext context) {
    //final appState = Provider.of<AppState>(context);
    return SizedBox(
      height: widget.totalHeight,
      child: ListView.builder(
        itemCount: widget.notifyEvents.length,
        itemBuilder: (context, index) {
          String formattedDate =
              DateFormat('d-M-y', Localizations.localeOf(context).languageCode)
                  .format(widget.notifyEvents[index].releaseDate);

          return itemDismissed[index]
              ? SizedBox.shrink()
              : ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.notifyEvents[index].name} - ',
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // Change the status to delete the item
                      setState(() {
                        itemDismissed[index] = true;
                      });

                      // Call the dismiss function and pass the event name
                      getEventAndDismiss(widget.notifyEvents[index].name);
                      if (itemDismissed.every((dismissed) => dismissed)) {
                        // Cerrar el Popover si todos los elementos se han eliminado
                        widget.closePopover();
                      }
                      widget.onEventDismissed();
                    },
                    color: Colors.black,
                    icon: const Icon(Icons.done),
                    splashRadius: 20,
                  ),
                );
        },
      ),
    );
  }
}

List<Event> getEventsWithinNextXHours(List<Event> events, int hours) {
  DateTime currentDateTime = DateTime.now();

  // Calculates the deadline for events (current + X hours)
  DateTime limitDateTime = currentDateTime.add(Duration(hours: hours));

  // Filters events between currentDateTime and limitDateTime
  List<Event> upcomingEvents = events.where((event) {
    return event.releaseDate.isAfter(currentDateTime) &&
        event.releaseDate.isBefore(limitDateTime);
  }).toList();

  return upcomingEvents;
}
