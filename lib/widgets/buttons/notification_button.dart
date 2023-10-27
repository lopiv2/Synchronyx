import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:popover/popover.dart';
import 'package:synchronyx/models/event.dart';
import 'package:synchronyx/providers/app_state.dart';

class NotificationButtonWidget extends StatefulWidget {
  final List<Event> eventsList;
  final AppState appState;

  const NotificationButtonWidget(
      {super.key, required this.eventsList, required this.appState});

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

    // Detener la animación después de un segundo
    await Future.delayed(const Duration(seconds: 1));
    _controller.stop();
    setState(() {
      _isRotating = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    _startRotation();
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
                          notifyEvents: notifyEvents, totalHeight: totalHeight);
                    },
                  );
                },
                direction: PopoverDirection.bottom,
                backgroundColor: Colors.green,
                width: 200,
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

class ListItems extends StatelessWidget {
  final List<Event> notifyEvents;
  final double totalHeight;

  const ListItems({
    Key? key,
    required this.notifyEvents,
    required this.totalHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: totalHeight, // Usar la altura calculada
        child: ListView.builder(
          itemCount: notifyEvents.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                '${notifyEvents[index].name} - ${notifyEvents[index].releaseDate.toLocal()}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
              trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.done), splashRadius: 20,),
            );
          },
        ));
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
