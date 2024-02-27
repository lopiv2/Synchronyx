import 'package:flutter/material.dart';
import 'package:lioncade/screens/steam/uplay_import_steps.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/icons/custom_icons_icons.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/screens/steam/steam_import_steps.dart';
import 'package:lioncade/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lioncade/utilities/generic_database_functions.dart'
    as databaseFunctions;
import 'package:lioncade/utilities/generic_api_functions.dart';
import 'package:lioncade/utilities/generic_functions.dart';
import 'package:lioncade/widgets/dialogs/emulators_list_dialog.dart';
import 'package:lioncade/widgets/dialogs/import_dialog.dart';
import 'package:lioncade/widgets/dialogs/settings_dialog.dart';
import '../models/api.dart';

MaterialStateProperty<Color?> myColor =
    MaterialStateProperty.resolveWith<Color?>(
  (Set<MaterialState> states) {
    return Constants.SIDE_BAR_COLOR; // Color normal
  },
);
// Crear una instancia de DioClient
DioClient dioClient = DioClient();

// ignore: must_be_immutable
class MyMenuBar extends StatelessWidget {
  final AppLocalizations appLocalizations;
  late PlatformStore store = PlatformStore.Amazon;

  MyMenuBar({Key? key, required this.appLocalizations}) : super(key: key);

  void _handleLastStepFinish(
      Map<String, dynamic> data, PlatformStore st, AppState appState) {
    var api = Api(
      name: '',
      url: '',
    );
    dynamic apiKeyValue;
    //If the api found is not null, I simply import the games with the data from the DB.
    if (Constants.foundApiBeforeImport != null) {
      api.name = Constants.foundApiBeforeImport!.name;
      api.url = Constants.foundApiBeforeImport!.url;
      apiKeyValue = Constants.foundApiBeforeImport!.getMetadata()['apiKey'];
    }
    switch (st) {
      case PlatformStore.Steam:
        dynamic steamIdValue;
        //If data is null, it means that the api data already exists.
        if (data.isEmpty) {
          //Only adds the SteamID case for Steam Platform
          steamIdValue =
              Constants.foundApiBeforeImport!.getMetadata()['steamId'];
        } //If not, create api data from zero
        else {
          api.name = 'Steam';
          api.url =
              'https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=';
          Map<String, dynamic> metadata = {
            'apiKey': '${data['steamApiController']}',
            'steamId': '${data['steamIdController']}',
          };
          api.setMetadata(metadata);
          steamIdValue = '${data['steamIdController']}';
          apiKeyValue = '${data['steamApiController']}';
          databaseFunctions.insertApi(api);
        }
        //appState.startImporting();
        dioClient
            .getAndImportSteamGames(
                key: apiKeyValue, steamId: steamIdValue, appState: appState)
            .then((_) {
          //appState.setImportingState('finished');
        }).catchError((error) {
          // Ocurrió un error al llamar al método getAndImportSteamGames
          // Aquí puedes manejar el error de acuerdo a tus necesidades
        });
        break;
      case PlatformStore.Uplay:
        if (appState.launcherLocation != null) {
          print(appState.launcherLocation! + 'cache\\configuration');
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          child: MenuBar(
            style: MenuStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return hexToColor(appState.themeApplied.sideBarColor);
              }),
            ),
            children: <Widget>[
              SubmenuButton(
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'MenuBar Sample',
                        applicationVersion: '1.0.0',
                      );
                    },
                    child: const MenuAcceleratorLabel('&About'),
                  ),
                  SubmenuButton(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'MenuBar Sample',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child: const MenuAcceleratorLabel('&Open'),
                      ),
                    ],
                    child: MenuAcceleratorLabel('&${appLocalizations.file}'),
                  ),
                ],
                child: MenuAcceleratorLabel('&${appLocalizations.menu}'),
              ),
              SubmenuButton(
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'MenuBar Sample',
                        applicationVersion: '1.0.0',
                      );
                    },
                    child: const MenuAcceleratorLabel('&About'),
                  ),
                  SubmenuButton(
                    leadingIcon: const Icon(Icons.swap_vertical_circle_rounded,
                        size: 20, color: Colors.blue),
                    menuChildren: <Widget>[
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.amazon_games,
                            color: Colors.orange, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor: Colors.orange,
                                titleIcon: CustomIcons.amazon_games,
                                title: appLocalizations.importAmazonWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  SteamImportSteps.step1(
                                    appLocalizations,
                                  ),
                                  //SteamImportSteps.step2(appLocalizations),
                                  // Add more steps as needed
                                ],
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importAmazon),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(
                          CustomIcons.battle_net,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor: Colors.blue,
                                titleIcon: CustomIcons.battle_net,
                                title: appLocalizations.importBattleWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  SteamImportSteps.step1(appLocalizations),
                                  //SteamImportSteps.step2(appLocalizations),
                                  // Add more steps as needed
                                ],
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importBattle),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.epicgames),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor: Colors.black,
                                titleIcon: CustomIcons.epicgames,
                                title: appLocalizations.importEpicWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  SteamImportSteps.step1(appLocalizations),
                                  //SteamImportSteps.step2(appLocalizations),
                                  // Add more steps as needed
                                ],
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importEpic),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.gog_dot_com,
                            color: Color.fromARGB(255, 84, 9, 97)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor: const Color.fromARGB(255, 84, 9, 97),
                                titleIcon: CustomIcons.gog_dot_com,
                                title: appLocalizations.importGogWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  SteamImportSteps.step1(appLocalizations),
                                  //SteamImportSteps.step2(appLocalizations),
                                  // Add more steps as needed
                                ],
                              );
                            },
                          );
                        },
                        child: MenuAcceleratorLabel(appLocalizations.importGog),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(
                          CustomIcons.itch_dot_io,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor: Colors.redAccent,
                                titleIcon: CustomIcons.itch_dot_io,
                                title: appLocalizations.importItchWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  SteamImportSteps.step1(appLocalizations),
                                  //SteamImportSteps.step2(appLocalizations),
                                  // Add more steps as needed
                                ],
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importItch),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.origin,
                            color: Colors.orange),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor: Colors.orange,
                                titleIcon: CustomIcons.origin,
                                title: appLocalizations.importOriginWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  SteamImportSteps.step1(appLocalizations),
                                  //SteamImportSteps.step2(appLocalizations),
                                  // Add more steps as needed
                                ],
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importOrigin),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.steam,
                            color: Color.fromARGB(255, 12, 66, 94)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return FutureBuilder<Api?>(
                                future:
                                    databaseFunctions.checkApiByName("Steam"),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Muestra un indicador de carga si estás esperando la respuesta
                                    return const CircularProgressIndicator();
                                  } else {
                                    // Verifica si Constants.foundApiBeforeImport es nulo o no
                                    bool apiExists = snapshot.data != null;

                                    List<Widget> steps = [
                                      SteamImportSteps.step1(appLocalizations),
                                    ];

                                    if (!apiExists) {
                                      steps.add(SteamImportSteps.step2(
                                          appLocalizations));
                                      steps.add(SteamImportSteps.step3(
                                          appLocalizations));
                                    }

                                    steps.add(SteamImportSteps.step4(
                                        appLocalizations,
                                        (data, st) => _handleLastStepFinish(
                                            data, st, appState),
                                        store));

                                    return ImportDialog(
                                      appLocalizations: appLocalizations,
                                      iconColor:
                                          const Color.fromARGB(255, 12, 66, 94),
                                      titleIcon: CustomIcons.steam,
                                      title: appLocalizations
                                          .importSteamWindowTitle,
                                      steps: steps,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importSteam),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(CustomIcons.ubisoft,
                            color: Colors.blueAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor: Colors.blueAccent,
                                titleIcon: CustomIcons.ubisoft,
                                title: appLocalizations.importUplayWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  UplayImportSteps.step1(appLocalizations),
                                  UplayImportSteps.step2(appLocalizations),
                                  UplayImportSteps.step3(
                                      appLocalizations,
                                      (data, st) => _handleLastStepFinish(
                                          data, st, appState),
                                      store)
                                ],
                              );
                            },
                          );
                        },
                        child: MenuAcceleratorLabel(appLocalizations.importUbi),
                      ),
                      MenuItemButton(
                        leadingIcon:
                            const Icon(CustomIcons.windows, color: Colors.blue),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor: Colors.blue,
                                titleIcon: CustomIcons.windows,
                                title:
                                    appLocalizations.importWindowsWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  SteamImportSteps.step1(appLocalizations),
                                  //SteamImportSteps.step2(appLocalizations),
                                  // Add more steps as needed
                                ],
                              );
                            },
                          );
                        },
                        child: MenuAcceleratorLabel(
                            appLocalizations.importWindows),
                      ),
                      MenuItemButton(
                        leadingIcon:
                            const Icon(CustomIcons.xbox, color: Colors.green),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ImportDialog(
                                appLocalizations: appLocalizations,
                                iconColor:
                                    const Color.fromARGB(255, 98, 219, 102),
                                titleIcon: CustomIcons.xbox,
                                title: appLocalizations.importXboxWindowTitle,
                                steps: [
                                  // Aquí colocas los widgets que representan el contenido de cada paso
                                  SteamImportSteps.step1(appLocalizations),
                                  //SteamImportSteps.step2(appLocalizations),
                                  // Add more steps as needed
                                ],
                              );
                            },
                          );
                        },
                        child:
                            MenuAcceleratorLabel(appLocalizations.importXbox),
                      ),
                    ],
                    child: MenuAcceleratorLabel(appLocalizations.import),
                  ),
                  SubmenuButton(
                    leadingIcon: const Icon(Icons.file_download,
                        size: 20, color: Color.fromARGB(255, 29, 121, 57)),
                    menuChildren: <Widget>[
                      MenuItemButton(
                        leadingIcon:
                            const Icon(CustomIcons.emulators, size: 20),
                        onPressed: () async {
                          await databaseFunctions
                              .insertEmulators(Constants.emulatorsList);
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return EmulatorListDialog(
                                  appLocalizations: appLocalizations);
                            },
                          );
                        },
                        child: MenuAcceleratorLabel(appLocalizations.emulators),
                      ),
                    ],
                    child: MenuAcceleratorLabel(appLocalizations.download),
                  ),
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.settings, size: 20),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return SettingsDialog(
                            appState: appState,
                            appLocalizations: appLocalizations,
                            iconColor: Colors.white,
                            titleIcon: Icons.settings,
                            title: appLocalizations.settings,
                          );
                        },
                      );
                    },
                    child:
                        MenuAcceleratorLabel('&${appLocalizations.settings}'),
                  ),
                ],
                child: MenuAcceleratorLabel('&${appLocalizations.tools}'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
