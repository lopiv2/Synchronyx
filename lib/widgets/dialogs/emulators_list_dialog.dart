import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:synchronyx/icons/custom_icons_icons.dart';
import 'package:synchronyx/models/emulators.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart';
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
    List<Emulators> listOfEmulators=[];
    return FutureBuilder<List<Emulators>>(
      future: getAllEmulators(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('Cargando datos...'); // Mensaje durante la carga inicial
        } else if (snapshot.data!.isEmpty) {
          return Text('');
        } else {
          listOfEmulators = snapshot.data!;
          return GenericDialog(
            appLocalizations: appLocalizations,
            content: content ??
                EmulatorContentDialog(
                  listOfEmulators: listOfEmulators,
                  appLocalizations: appLocalizations,
                ),
            dialogTitle: appLocalizations.emulators,
            icon: Icon(CustomIcons.emulators, size: 20),
          );
        }
      },
    );
  }
}

class EmulatorContentDialog extends StatelessWidget {
  final AppLocalizations appLocalizations;
  final List<Emulators> listOfEmulators;
  const EmulatorContentDialog(
      {Key? key, required this.appLocalizations, required this.listOfEmulators})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the list of unique platforms
    List<String> platforms = getUniquePlatforms(listOfEmulators);

    // Create a map that associates each platform with a list of corresponding emulators.
    Map<String, List<Emulators>> emulatorsByPlatform = {};

    // Initializing the map with empty lists for each platform
    platforms.forEach((platform) {
      emulatorsByPlatform[platform] = [];
    });

    // Organize emulators on the map according to their platform
    listOfEmulators.forEach((emulator) {
      List<String> emulatorPlatforms = emulator.systems.split(',');
      emulatorPlatforms =
          emulatorPlatforms.map((platform) => platform.trim()).toList();

      // Associating the emulator with each of its platforms
      emulatorPlatforms.forEach((platform) {
        emulatorsByPlatform[platform]?.add(emulator);
      });
    });

    // Create GFAccordion widgets for each platform and its emulators

    List<Widget> accordionWidgets = platforms.map((platform) {
      List<Emulators> platformEmulators = emulatorsByPlatform[platform] ?? [];

      List<Widget> emulatorWidgets = platformEmulators.map((emulator) {
        return Column(
          children: [
            Container(
              width: double.infinity, // O ajusta el ancho según tus necesidades
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/${emulator.icon}'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Text(
              '${emulator.name}',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        );
      }).toList();

      // Create a GridView for emulator texts
      Widget gridView = GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Cambia esto según tus preferencias
        ),
        shrinkWrap: true, // Ajustar al contenido
        itemCount: emulatorWidgets.length,
        itemBuilder: (BuildContext context, int index) {
          return emulatorWidgets[index];
        },
      );

      // Create the accordion for this platform
      return GFAccordion(
        title: platform,
        contentChild: gridView,
        collapsedIcon: const Icon(Icons.add),
        expandedIcon: const Icon(Icons.minimize),
      );
    }).toList();

    return Column(
      children: accordionWidgets,
    );
  }
}
