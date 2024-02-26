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
  factory UplayImportSteps.step2(
    AppLocalizations appLocalizations,
    bool showLoadingCircleProgress
  ) {
    TextEditingController steamIdController = TextEditingController();

    // Función asincrónica para realizar la comprobación
    return UplayImportSteps(
      content: FutureBuilder<bool>(
        future: checkIfAppInstalled("Uplay"),
        builder: (context, snapshot) {
          {
            if (snapshot.connectionState == ConnectionState.waiting || showLoadingCircleProgress) {
              // Muestra el indicador de carga mientras se realiza la comprobación
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                // Maneja errores si ocurren durante la comprobación
                return Text('Error: ${snapshot.error}');
              } else {
                // Si la comprobación se realizó con éxito, muestra el resultado
                bool isAppInstalled = snapshot.data ?? false;
                return Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 40, top: 10, right: 10),
                  child: Column(
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
                        children: [
                          isAppInstalled
                              ? Text('La aplicación está instalada')
                              : Text('La aplicación no está instalada'),
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextField(
                                  controller: steamIdController,
                                  enabled: true,
                                  enableInteractiveSelection: true,
                                  style: const TextStyle(color: Colors.white),
                                  onSubmitted: (value) {},
                                  // Add properties to the TextField as needed
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            }
          }
        },
      ),
      appLocalizations: appLocalizations,
    );
  }

//API key
  factory UplayImportSteps.step3(AppLocalizations appLocalizations) {
    TextEditingController steamApiController = TextEditingController();
    Map<String, TextEditingController> controller2Map = {
      'steamApiController': steamApiController,
    };
    Constants.controllerMapList.add(controller2Map);
    return UplayImportSteps(
      content: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 40, top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.steamWindowAssistantTitleStep3,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("57FE16708AA112A68828C14A7469D21E"),
            const SizedBox(height: 20),
            Text(
              appLocalizations.steamWindowAssistantStep3,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Text(
                  appLocalizations.apiKeyText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: steamApiController,
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (value) {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appLocalizations: appLocalizations,
    );
  }

  factory UplayImportSteps.step4(
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
                  appLocalizations.steamWindowAssistantStep4,
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
                        onFinish(collectedData, PlatformStore.Steam);
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
