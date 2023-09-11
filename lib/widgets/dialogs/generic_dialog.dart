import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/audio_singleton.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenericDialog extends StatelessWidget {
  GenericDialog({super.key, required this.appLocalizations, required this.content});
  final AppLocalizations appLocalizations;
  final AudioManager audioManager = AudioManager();
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final indexSelected = ValueNotifier<int>(-1);

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 2, 34, 14),
                width: 0.2,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Constants.SIDE_BAR_COLOR,
                  Color.fromARGB(255, 33, 109, 72),
                  Color.fromARGB(255, 48, 87, 3),
                ],
              ),
            ),
            child: Stack(children: [
              Positioned.fill(
                  child: Column(
                children: [
                  AppBar(
                    backgroundColor: Constants.SIDE_BAR_COLOR,
                    elevation: 0.0,
                    toolbarHeight: 35.0,
                    titleSpacing: -20.0,
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.audiotrack,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      appLocalizations.importOstWindowTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Text(
                      appLocalizations
                          .importOstForGame(appState.selectedGame!.game.title),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(height: 200, child: content),
                      ],
                    ),
                  ),
                ],
              )),
              Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromARGB(255, 48, 87, 3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        audioManager.currentUrlNotifier.value = '';
                        audioManager.isPlayingNotifier.value = false;
                        audioManager.audioPlayer.dispose;
                        audioManager.stop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Change the button color to red
                      ),
                      child: Text(appLocalizations.cancel),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            ])));
  }
}