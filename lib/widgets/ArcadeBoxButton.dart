import 'package:flutter/material.dart';


class ArcadeBoxButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Color de fondo transparente del Material
      borderRadius: BorderRadius.circular(8.0), // Radio de las esquinas del botón
      child: Ink.image(
        image: AssetImage('assets/buttons/ArcadeBoxButton.png'), // Ruta de tu imagen personalizada
        fit: BoxFit.cover, // Ajustar la imagen al tamaño del botón
        width: 64,
        height: 64,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0), // Radio de las esquinas del botón
          onTap: () {
            // Aquí puedes agregar la lógica que desees al hacer clic en el botón.
            print('Botón personalizado presionado');
          },
          child: Container(
            width: 64,
            height: 64,
          ),
        ),
      ),
    );
  }
}
