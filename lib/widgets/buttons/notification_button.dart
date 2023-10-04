import 'package:flutter/material.dart';
import 'package:synchronyx/models/game.dart';

var game = Game(
  id: 0,
  title: 'Fido',
  description: 'prueba',
  lastPlayed: DateTime.now(),
);

class NotificationButtonWidget extends StatelessWidget {
  const NotificationButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Color de fondo transparente del Material
      borderRadius:
          BorderRadius.circular(8.0), // Radio de las esquinas del botón
      child: IconButton(
        onPressed: () {},
        icon: Icon(Icons.notifications),
        color: Colors.white,
      ),
    );
  }
}
