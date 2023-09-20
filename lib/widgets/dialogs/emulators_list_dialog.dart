import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/icons/custom_icons_icons.dart';
import 'package:synchronyx/models/emulators.dart';
import 'package:synchronyx/models/responses/emulator_download_response.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart';
import 'package:synchronyx/utilities/generic_functions.dart';
import 'package:synchronyx/widgets/dialogs/download_progress_dialog.dart';
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
    List<Emulators> listOfEmulators = [];
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
            dialogHeader: appLocalizations.emulators,
            preContent: const DownloadProgress(),
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
    final appState = Provider.of<AppState>(context, listen: false);
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
      bool found =
          false; // Variable para controlar si se ha encontrado una coincidencia

      GamePlatforms g = GamePlatforms.values.firstWhere(
        (element) {
          if (!found) {
            // Si aún no se ha encontrado una coincidencia
            final names = element.name.split(
                ','); // Divide la cadena en múltiples valores usando comas

            for (var name in names) {
              if (name.trim().toLowerCase() == platform.toLowerCase()) {
                found = true; // Marca que se ha encontrado una coincidencia
                return true; // Retorna true para detener la búsqueda
              }
            }
          }
          return false; // Continúa buscando
        },
      );
      Image im = g.image;
      List<Widget> emulatorWidgets = platformEmulators.map((emulator) {
        return FutureBuilder<List<EmulatorDownloadResponse>>(
          future: selectEmulatorScrapper(emulator.name, emulator.url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras se obtienen los datos
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Maneja errores si ocurren
              return Text('Error: ${snapshot.error}');
            } else {
              // Obtiene la respuesta de la función asincrónica
              List<EmulatorDownloadResponse> response = snapshot.data ?? [];
              List<Widget> iconButtons = response.map((response) {
                return IconButton(
                  icon: Icon(response.image), // Carga la imagen desde assets
                  onPressed: () {
                    appState.startDownload(response.url!);
                    //downloadFile(response.url!);
                  },
                );
              }).toList();
              return Column(
                children: [
                  Container(
                    width: double
                        .infinity, // O ajusta el ancho según tus necesidades
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: iconButtons)
                  // Otros widgets de texto con otros valores de la respuesta, si es necesario
                ],
              );
            }
          },
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
        titleChild: Row(
          children: [
            Text(platform), 
            SizedBox(width: 8.0), 
            Image(
              image: im.image, 
              width: 60, 
              height: 60, 
              fit: BoxFit
                  .contain, 
            ),
          ],
        ),
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
