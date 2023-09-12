import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:synchronyx/models/emulators.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:synchronyx/utilities/generic_functions.dart';
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
      content: content ??
          EmulatorContentDialog(
            appLocalizations: appLocalizations,
          ),
      dialogTitle: appLocalizations.accept,
    );
  }
}

class EmulatorContentDialog extends StatelessWidget {
  final AppLocalizations appLocalizations;
  const EmulatorContentDialog({Key? key, required this.appLocalizations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the list of unique platforms
    List<String> platforms = getUniquePlatforms();

    // Create a map that associates each platform with a list of corresponding emulators.
    Map<String, List<Emulators>> emulatorsByPlatform = {};

    // Initializing the map with empty lists for each platform
    platforms.forEach((platform) {
      emulatorsByPlatform[platform] = [];
    });

    // Organize emulators on the map according to their platform
    Constants.emulatorsList.forEach((emulator) {
      List<String> emulatorPlatforms = emulator.systems.split(',');
      emulatorPlatforms =
          emulatorPlatforms.map((platform) => platform.trim()).toList();

      // Associating the emulator with each of its platforms
      emulatorPlatforms.forEach((platform) {
        emulatorsByPlatform[platform]?.add(emulator);
      });
    });

    // Crear los widgets de GFAccordion para cada plataforma y sus emuladores

    List<Widget> accordionWidgets = platforms.map((platform) {
      List<Emulators> platformEmulators = emulatorsByPlatform[platform] ?? [];

      // Crear una lista de textos para los emuladores
      List<Widget> emulatorTexts = platformEmulators.map((emulator) {
        return Text(
          '${emulator.name}',
          style: TextStyle(
              color: Colors
                  .black), // Cambia el estilo del texto según tus preferencias
        );
      }).toList();

      // Crear un GridView para los textos de emuladores
      Widget gridView = GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Cambia esto según tus preferencias
        ),
        physics:
            NeverScrollableScrollPhysics(), // Deshabilitar el desplazamiento del GridView
        shrinkWrap: true, // Ajustar al contenido
        itemCount: emulatorTexts.length,
        itemBuilder: (BuildContext context, int index) {
          return emulatorTexts[index];
        },
      );

      // Crear el acordeón para esta plataforma
      return GFAccordion(
        title: platform,
        contentChild: SingleChildScrollView(
          child: gridView,
        ),
        collapsedIcon: const Icon(Icons.add),
        expandedIcon: const Icon(Icons.minimize),
      );
    }).toList();

    return Column(
      children: accordionWidgets,
    );
  }
}
