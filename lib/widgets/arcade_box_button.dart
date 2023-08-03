import 'package:flutter/material.dart';
import 'package:synchronyx/models/game.dart';
import 'package:synchronyx/utilities/generic_functions.dart';

  var game = Game(
    id: 0,
    title: 'Fido',
    description: 'prueba',
  );

class ArcadeBoxButtonWidget extends StatelessWidget {
  const ArcadeBoxButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Color de fondo transparente del Material
      borderRadius:
          BorderRadius.circular(8.0), // Radio de las esquinas del botón
      child: Ink.image(
        image: const AssetImage(
            'assets/buttons/ArcadeBoxButton.png'), // Ruta de tu imagen personalizada
        fit: BoxFit.cover, // Ajustar la imagen al tamaño del botón
        width: 45,
        height: 45,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(8.0), // Radio de las esquinas del botón
          onTap: () {
            // Aquí puedes agregar la lógica que desees al hacer clic en el botón.
            //insertGame(game as Game);
            print('Botón personalizado presionado');
          },
          child: Container(
            width: 45,
            height: 45,
          ),
        ),
      ),
    );
  }
}
