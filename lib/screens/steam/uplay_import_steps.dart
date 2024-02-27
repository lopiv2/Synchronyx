import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lioncade/utilities/generic_functions.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/models/api.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/screens/generic_import_step.dart';
import 'package:lioncade/utilities/generic_database_functions.dart'
    // ignore: library_prefixes
    as databaseFunctions;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lioncade/utilities/constants.dart';

typedef OnFinishCallback = void Function(
    Map<String, dynamic> collectedData, PlatformStore store);

typedef StateUpdater = void Function();

class UplayImportSteps extends StatefulWidget {
  final Widget content;
  final AppLocalizations? appLocalizations;
  final Function(String)? onTextFieldSubmitted;
  final BuildContext? context;

  static Map<String, dynamic> _collectDataFromControllers() {
    Map<String, dynamic> collectedData = {};

    for (int i = 0; i < Constants.controllerMapList.length; i++) {
      // Obtener el mapa de controladores correspondiente al paso i
      Map<String, TextEditingController> controllerMap =
          Constants.controllerMapList[i];

      // Recorrer las claves (keys) del mapa y obtener los valores de los controladores
      controllerMap.forEach((key, controller) {
        collectedData[key] = controller.text;
      });
    }
    return collectedData;
  }

  const UplayImportSteps({
    Key? key,
    required this.content,
    this.appLocalizations,
    this.onTextFieldSubmitted,
    this.context,
  }) : super(key: key);

  factory UplayImportSteps.step1(AppLocalizations appLocalizations) {
    return UplayImportSteps(
      content: GenericImportStep(
        stepContentTitleText: appLocalizations.uplayWindowAssistant,
        stepContentDescriptionText: appLocalizations.uplayWindowAssistantStep1,
      ),
      appLocalizations: appLocalizations,
    );
  }

//UPlay installed or not
  factory UplayImportSteps.step2(AppLocalizations appLocalizations) {
    TextEditingController steamIdController = TextEditingController();
    bool isAppInstalled = false;
    // Función asincrónica para realizar la comprobación
    return UplayImportSteps(
      content: Consumer<AppState>(builder: (context, appState, _) {
        return FutureBuilder<Map<String, dynamic>?>(
            future: checkIfAppInstalled("Uplay", 3),
            builder: (context, snapshot) {
              {
                isAppInstalled = snapshot.data?['isInstalled'] ?? false;
                appState.launcherLocation = snapshot.data?['location'];
                //print(appState.launcherLocation);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations.uplayWindowAssistantTitleStep2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      appLocalizations.uplayWindowAssistantStep2,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        snapshot.connectionState == ConnectionState.waiting
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : snapshot.hasError
                                ?
                                // Maneja errores si ocurren durante la comprobación
                                Text('Error: ${snapshot.error}')
                                : isAppInstalled
                                    ? Column(
                                        children: [
                                          Text(
                                            appLocalizations.appInstalled,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 20),
                                                Text(
                                                  appLocalizations
                                                      .nextForContinue,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ])
                                        ],
                                      )
                                    : Text(appLocalizations.appNotInstalled,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                );
              }
            });
      }),
      appLocalizations: appLocalizations,
    );
  }

  factory UplayImportSteps.step3(
    AppLocalizations appLocalizations,
    OnFinishCallback onFinish,
    PlatformStore selectedPlatform,
  ) {
    return UplayImportSteps(
      content: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 40, top: 10, right: 10),
        child: Consumer<AppState>(
          builder: (context, appState, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizations.steamWindowAssistantTitleStep4,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  appLocalizations.uplayWindowAssistantStep4,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> collectedData =
                            _collectDataFromControllers();
                        onFinish(collectedData, PlatformStore.Uplay);
                        appState.setImportingState('importing');
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: Text(appLocalizations.start),
                    ),
                  ],
                ),
                appState.isImporting == 'importing'
                    ? Column(
                        children: [
                          /*const CircularProgressIndicator(),
                          const SizedBox(
                            height: 10,
                          ),*/
                          Text(appState.gameBeingImported),
                        ],
                      ) // Show progress indicator if import is in progress
                    : appState.isImporting == 'finished'
                        ? Text(appLocalizations
                            .finished) // Show 'Finished' if import is completed
                        : const Text(''),
                const LinearProgressWidget(),
              ],
            );
          },
        ),
      ),
      appLocalizations: appLocalizations,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _UplayImportStepsState createState() => _UplayImportStepsState();
}

class LinearProgressWidget extends StatelessWidget {
  const LinearProgressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Column(
      children: [
        LinearProgressIndicator(
          value: appState.importProgress,
          minHeight: 20.0,
          backgroundColor: Colors.grey,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        appState.isImporting == 'importing'
            ? Text('${(appState.importProgress) * 100}%')
            : const Text(''),
      ],
    );
  }
}

class _UplayImportStepsState extends State<UplayImportSteps> {
  @override
  void initState() {
    super.initState();
    _loadFoundApi();
  }

  Future<void> _loadFoundApi() async {
    final Api? foundApi = await databaseFunctions.checkApiByName("Steam");
    setState(() {
      Constants.foundApiBeforeImport = foundApi;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.content;
  }
}
