import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:synchronyx/widgets/dialogs/generic_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmulatorListDialog extends StatelessWidget {
  final EmulatorContentDialog? content;
  final AppLocalizations appLocalizations;

  const EmulatorListDialog({
    Key? key, // Agrega la declaración del parámetro key
    required this.appLocalizations,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericDialog(
        appLocalizations: appLocalizations,
        content: content ?? EmulatorContentDialog());
  }
}

class EmulatorContentDialog extends StatelessWidget {
  const EmulatorContentDialog({Key? key})
      : super(
            key:
                key); // Usa super(key: key) para inicializar correctamente la clase base

  @override
  Widget build(BuildContext context) {
    return const Placeholder(child: Text("prueba"));
  }
}
