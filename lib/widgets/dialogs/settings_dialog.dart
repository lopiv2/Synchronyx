import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lioncade/models/global_options.dart';
import 'package:lioncade/providers/app_state.dart';
import 'package:lioncade/screens/options/calendar_visual_options.dart';
import 'package:lioncade/screens/options/game_visual_options.dart';
import 'package:lioncade/screens/options/theme_visual_options.dart';
import 'package:lioncade/utilities/audio_singleton.dart';
import 'package:lioncade/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lioncade/utilities/generic_database_functions.dart';
import 'package:lioncade/utilities/generic_functions.dart';
import 'package:lioncade/widgets/options_tree_view.dart';

import 'custom_dialog.dart';

class SettingsDialog extends StatefulWidget {
  final IconData titleIcon;
  final String title;
  final Color iconColor;
  final AppLocalizations appLocalizations;
  final AppState appState;
  final Function(Map<String, dynamic>)? onFinish;

  const SettingsDialog({
    Key? key,
    required this.titleIcon,
    required this.title,
    required this.appLocalizations,
    this.onFinish,
    this.iconColor = Colors.white,
    required this.appState,
  }) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  Offset _offset = const Offset(0, 0);
  final List<String> options = ['Option 1', 'Option 2', 'Option 3'];
  final AudioManager audioManager = AudioManager();

  void initState() {
    super.initState();
    audioManager.pause();
  }

  @override
  void dispose() {
    if (widget.appState.selectedOptions.playOSTOnSelectGame == 1) {
      audioManager.resume();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
      },
      child: CustomDialog(
        offset: _offset,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 2, 34, 14),
              width: 0.2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                hexToColor(appState.themeApplied.backgroundStartColor),
                hexToColor(appState.themeApplied.backgroundMediumColor),
                hexToColor(appState.themeApplied.backgroundEndColor),
              ],
            ),
          ),
          child: Column(children: [
            AppBar(
              backgroundColor: hexToColor(appState.themeApplied.sideBarColor),
              elevation: 0.0,
              toolbarHeight: 35.0,
              titleSpacing: -20.0,
              leading: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(
                  widget.titleIcon,
                  color: widget.iconColor,
                ),
              ),
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    appState.optionsResponse =
                        GlobalOptions.copy(appState.selectedOptions);
                    Navigator.of(context).pop();
                    if (appState.selectedOptions.playOSTOnSelectGame == 1) {
                      audioManager.resume();
                    }
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    LeftColumn(
                      options: options,
                      appLocalizations: widget.appLocalizations,
                    ),
                    const SizedBox(width: 16),
                    ValueListenableBuilder<String>(
                        valueListenable: appState.selectedOptionClicked,
                        builder: (context, selectedOption, child) {
                          return RightColumn(
                            appLocalizations: widget.appLocalizations,
                            optionClicked: selectedOption,
                          );
                        }),
                    const SizedBox(width: 16),
                  ],
                )),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: hexToColor(appState.themeApplied.backgroundEndColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //I update the data base with the data obtained from the configuration.
                        updateOptions(appState.optionsResponse);
                        //I am updating the general data of this session with the new
                        appState.selectedOptions =
                            GlobalOptions.copy(appState.optionsResponse);
                        Navigator.of(context).pop();
                        audioManager.resume();
                        appState.refreshGridView();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue, // Change the button color to red
                      ),
                      child: Text(widget.appLocalizations.accept),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        appState.optionsResponse =
                            GlobalOptions.copy(appState.selectedOptions);
                        Navigator.of(context).pop();
                        if (appState.selectedOptions.playOSTOnSelectGame == 1) {
                          audioManager.resume();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Change the button color to red
                      ),
                      child: Text(widget.appLocalizations.cancel),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class LeftColumn extends StatelessWidget {
  final List<String> options;
  final AppLocalizations appLocalizations;

  LeftColumn({required this.options, required this.appLocalizations});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Expanded(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 2, 34, 14), // Color del borde
            width: 0.2, // Ancho del borde
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              hexToColor(appState.themeApplied.backgroundStartColor),
              hexToColor(appState.themeApplied.backgroundMediumColor),
              hexToColor(appState.themeApplied.backgroundEndColor),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.60,
        width: MediaQuery.of(context).size.width * 0.15,
        child: OptionsTreeView(
          appLocalizations: appLocalizations,
        ),
      )
    ]));
  }
}

class RightColumn extends StatelessWidget {
  final AppLocalizations appLocalizations;
  RightColumn({required String optionClicked, required this.appLocalizations});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Expanded(
        flex: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width * 0.27,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(17, 238, 238, 238),
                border: Border.all(
                  color: Colors.grey, // Color del borde
                  width: 1.0, // Ancho del borde
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(2.0)), // Radio del borde
              ),
              child: buildOptions(appState, appLocalizations),
            )
          ],
        ));
  }

  Widget buildOptions(AppState appState, appLocalizations) {
    switch (appState.selectedOptionClicked.value) {
      case "games":
        return GameVisualOptions(appLocalizations: appLocalizations);
      case "calendar":
        return CalendarVisualOptions(appLocalizations: appLocalizations);
      case "theme":
        return ThemeVisualOptions(appLocalizations: appLocalizations);
      default:
        return const Text("data");
    }
  }
}
