import 'package:flutter/material.dart';

class GenericImportStep extends StatelessWidget {
  final String stepContentText; // Nuevo campo para el contenido del paso
  final Widget? content;

  const GenericImportStep({
    Key? key,
    required this.stepContentText,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        stepContentText, // Usar el valor del campo stepContent en lugar del texto fijo
        style: TextStyle(fontSize: 18),
      ),
    ); // Utilizar el widget proporcionado en lugar de mostrar el texto directamente
  }
}
