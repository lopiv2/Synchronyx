import 'package:flutter/material.dart';
import 'package:synchronyx/models/api.dart';
import 'package:synchronyx/screens/generic_import_step.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart'
    as databaseFunctions;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/utilities/constants.dart';

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
        collectedData['$key'] = controller.text;
      });
    }
    return collectedData;
  }

  SteamImportSteps({
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
            Text("76561198013304798"),
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
                        style: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
                        onSubmitted: (value) {
                          // Guardar el valor ingresado en la variable
                          //String steamApi = Constants.con[1].text;
                          // Aquí puedes hacer lo que quieras con el valor ingresado
                          // Por ejemplo, imprimirlo en la consola:
                          //print('Steam Api: $steamApi');
                        },
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
    OnFinishCallback onFinish, // Modificado para aceptar el enum
    PlatformStore selectedPlatform,
  ) {
    return SteamImportSteps(
      content: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 40, top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.steamWindowAssistantTitleStep4,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  onPressed: () {
                    Map<String, dynamic> collectedData =
                        _collectDataFromControllers();
                    // Llamar a la función de callback para entregar los datos recopilados
                    onFinish(collectedData, PlatformStore.Steam);
                    // Cerrar el diálogo después de enviar los datos
                    //Navigator.of(context).pop();
                  },
                  child: Text(appLocalizations.finish),
                ),
              ],
            )
          ],
        ),
      ),
      appLocalizations: appLocalizations,
    );
  }

  @override
  _SteamImportStepsState createState() => _SteamImportStepsState();
}

class _SteamImportStepsState extends State<SteamImportSteps> {
  @override
  void initState() {
    super.initState();
    _loadFoundApi();
    //widget.steamIdController.addListener(_printLatestValue);
  }

  Future<void> _loadFoundApi() async {
    final Api? foundApi = await databaseFunctions.checkApiByName("Steam");
    setState(() {
      Constants.foundApiBeforeImport = foundApi;
    });
  }

  @override
  void dispose() {
    //widget.steamIdController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    //print('Second text field: ${widget.steamIdController.text}');
  }

  @override
  Widget build(BuildContext context) {
    //print(Constants.foundApiBeforeImport);
    return widget.content;
  }
}
