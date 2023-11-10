import 'package:flutter/material.dart';
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

class SteamImportSteps extends StatefulWidget {
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

  const SteamImportSteps({
    Key? key,
    required this.content,
    this.appLocalizations,
    this.onTextFieldSubmitted,
  }) : super(key: key);

  factory SteamImportSteps.step1(AppLocalizations appLocalizations) {
    return SteamImportSteps(
      content: GenericImportStep(
        stepContentTitleText: appLocalizations.steamWindowAssistant,
        stepContentDescriptionText: appLocalizations.steamWindowAssistantStep1,
      ),
      appLocalizations: appLocalizations,
    );
  }

//STEAM ID
  factory SteamImportSteps.step2(
    AppLocalizations appLocalizations,
  ) {
    TextEditingController steamIdController = TextEditingController();
    Map<String, TextEditingController> controller1Map = {
      'steamIdController': steamIdController,
    };
    Constants.controllerMapList.add(controller1Map);
    return SteamImportSteps(
      content: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 40, top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.steamWindowAssistantTitleStep2,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("76561198013304798"),
            const SizedBox(height: 20),
            Text(
              appLocalizations.steamWindowAssistantStep2,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                const Text(
                  "http://steamcommunity.com/id/",
                  style: TextStyle(
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
      ),
      appLocalizations: appLocalizations,
    );
  }

//API key
  factory SteamImportSteps.step3(AppLocalizations appLocalizations) {
    TextEditingController steamApiController = TextEditingController();
    Map<String, TextEditingController> controller2Map = {
      'steamApiController': steamApiController,
    };
    Constants.controllerMapList.add(controller2Map);
    return SteamImportSteps(
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

  factory SteamImportSteps.step4(
    AppLocalizations appLocalizations,
    OnFinishCallback onFinish,
    PlatformStore selectedPlatform,
  ) {
    return SteamImportSteps(
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
  _SteamImportStepsState createState() => _SteamImportStepsState();
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

class _SteamImportStepsState extends State<SteamImportSteps> {
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
