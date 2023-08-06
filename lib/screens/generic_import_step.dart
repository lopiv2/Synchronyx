import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenericImportStep extends StatelessWidget {
  final String stepContentTitleText; // Nuevo campo para el contenido del paso
  final String
      stepContentDescriptionText; // Nuevo campo para el contenido del paso
  final Widget? content;
  final AppLocalizations? appLocalizations;

  const GenericImportStep({
    Key? key,
    required this.stepContentTitleText,
    required this.stepContentDescriptionText,
    this.appLocalizations,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 40, top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepContentTitleText, // Usar el valor del campo stepContent en lugar del texto fijo
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              stepContentDescriptionText, // Usar el valor del campo stepContent en lugar del texto fijo
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              appLocalizations?.nextForContinue ??
                  '', // Use null-aware operator and provide a default value (empty string in this case)
              style: TextStyle(fontSize: 14),
            )
          ],
        )); // Utilizar el widget proporcionado en lugar de mostrar el texto directamente
  }
}
