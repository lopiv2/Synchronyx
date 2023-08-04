import 'package:flutter/material.dart';
import 'package:synchronyx/screens/generic_import_step.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SteamImportSteps extends StatelessWidget {
  final Widget content; // Cambiar el tipo a Widget
  final AppLocalizations? appLocalizations;

  const SteamImportSteps(
      {Key? key, required this.content, this.appLocalizations})
      : super(key: key);

  factory SteamImportSteps.step1(AppLocalizations appLocalizations) {
    return SteamImportSteps(
      content: GenericImportStep(
          stepContentText: appLocalizations.steamWindowAssistant),
      appLocalizations: appLocalizations,
    );
  }

  factory SteamImportSteps.step2() {
    return SteamImportSteps(
      content: Center(
        child: Image.asset(
          'assets/images/SegaDreamcast.png', // Cambiar la ruta de la imagen según tus necesidades
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  factory SteamImportSteps.step3() {
    return SteamImportSteps(
      content: Center(
        child: Text(
          'Step 3 Content',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return content; // Utilizar el widget proporcionado en lugar de mostrar el texto directamente
  }
}
