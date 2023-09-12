import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:synchronyx/models/responses/khinsider_response.dart';
import 'package:synchronyx/providers/app_state.dart';
import 'package:synchronyx/utilities/audio_singleton.dart';
import 'package:synchronyx/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronyx/utilities/generic_api_functions.dart';
import 'package:synchronyx/utilities/generic_database_functions.dart';
import 'package:synchronyx/utilities/generic_functions.dart';
import 'package:synchronyx/widgets/buttons/icon_button_colored.dart';
import 'package:synchronyx/widgets/dialogs/import_dialog.dart';

class OstDownloadDialog extends StatefulWidget {
  OstDownloadDialog({super.key, required this.appLocalizations});
  final AppLocalizations appLocalizations;

  @override
  State<OstDownloadDialog> createState() => _OstDownloadDialogState();
}

class _OstDownloadDialogState extends State<OstDownloadDialog> {
  final AudioManager audioManager = AudioManager();
  Offset _offset = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    String title = appState.selectedGame!.game.title;
    List<KhinsiderResponse> responses = [];
    final indexSelected = ValueNotifier<int>(-1);
    final trackIndexSelected = ValueNotifier<int>(-1);
    double _currentPosition = 0.0;
    double _totalDuration = 0.0;
    final ValueNotifier<bool> tog = ValueNotifier<bool>(false);

    void toggleVisibility() {
      tog.value = !tog.value; // Cambia el valor de tog y notifica a los oyentes
    }

    return GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _offset += details.delta;
          });
        },
        child: CustomDialog(
          offset: _offset,
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
            child: Stack(
              children: [
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
                          widget.appLocalizations.importOstWindowTitle,
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
                          widget.appLocalizations.importOstForGame(
                              appState.selectedGame!.game.title),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.appLocalizations.results,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            SingleChildScrollView(
                                child: Column(children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.225,
                                child: FutureBuilder<List<KhinsiderResponse>>(
                                  future:
                                      DioClient().scrapeKhinsider(title: title),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<KhinsiderResponse>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        child: Center(
                                          child: Transform.scale(
                                            scale:
                                                1, // Adjusts the scaling value to make the CircularProgressIndicator smaller.
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Text(
                                          'No se encontraron resultados');
                                    } else {
                                      responses = snapshot.data!;
                                      return SingleChildScrollView(
                                          child: Table(
                                        border:
                                            TableBorder.all(color: Colors.grey),
                                        defaultColumnWidth:
                                            FixedColumnWidth(150.0),
                                        children:
                                            responses.map((khinsiderResponse) {
                                          final currentIndex = responses
                                              .indexOf(khinsiderResponse);
                                          return TableRow(
                                            children: [
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Text(khinsiderResponse
                                                    .nameAlbum),
                                              ),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Text(khinsiderResponse
                                                    .platform!),
                                              ),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Text(
                                                  khinsiderResponse.year
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: ElevatedButton(
                                                  child: Text(
                                                      appState.showMoreContent ==
                                                              false
                                                          ? 'Seleccionar'
                                                          : 'Más'),
                                                  onPressed: () {
                                                    indexSelected.value =
                                                        currentIndex;
                                                    toggleVisibility();
                                                  }, // Agrega el botón "Más" aquí
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ));
                                    }
                                  },
                                ),
                              )
                            ])),
                            SizedBox(
                              height: 16,
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: indexSelected,
                              builder: (context, selectedIndex, child) {
                                return Visibility(
                                  visible: selectedIndex != -1,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.appLocalizations.trackList,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Table(
                                            border: TableBorder.all(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            columnWidths: const {
                                              0: FlexColumnWidth(0.5),
                                              1: FlexColumnWidth(1),
                                              2: FlexColumnWidth(0.5),
                                              3: FlexColumnWidth(0.5),
                                              4: FlexColumnWidth(1),
                                            },
                                            children: [
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Center(
                                                          child: Text(widget
                                                              .appLocalizations
                                                              .number))),
                                                  TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Center(
                                                          child: Text(widget
                                                              .appLocalizations
                                                              .title))),
                                                  TableCell(
                                                      child: Text(widget
                                                          .appLocalizations
                                                          .length)),
                                                  TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Center(
                                                          child: Text(widget
                                                              .appLocalizations
                                                              .size))),
                                                  TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Center(
                                                          child: Text(''))),
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    child: Center(
                                                      child: Text(widget
                                                          .appLocalizations
                                                          .actions),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: indexSelected,
                              builder: (context, selectedIndex, child) {
                                return Visibility(
                                  visible: selectedIndex != -1,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    height: MediaQuery.of(context).size.height *
                                        0.16,
                                    child: ListView(
                                      children: [
                                        Table(
                                          border: TableBorder.all(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          columnWidths: const {
                                            0: FlexColumnWidth(0.5),
                                            1: FlexColumnWidth(1),
                                            2: FlexColumnWidth(0.5),
                                            3: FlexColumnWidth(0.5),
                                            4: FlexColumnWidth(1),
                                          },
                                          children: [
                                            if (selectedIndex != -1)
                                              for (int i = 0;
                                                  i <
                                                      responses[selectedIndex]
                                                          .tracks
                                                          .length;
                                                  i++)
                                                TableRow(
                                                  decoration: BoxDecoration(
                                                    color: i % 2 == 0
                                                        ? Color.fromARGB(
                                                            143, 14, 73, 27)
                                                        : Color.fromARGB(
                                                            255,
                                                            64,
                                                            124,
                                                            69), // Alterna los colores de fondo
                                                  ),
                                                  children: [
                                                    TableCell(
                                                        verticalAlignment:
                                                            TableCellVerticalAlignment
                                                                .middle,
                                                        child: Center(
                                                          child: Text(
                                                            responses[
                                                                    selectedIndex]
                                                                .tracks[i]
                                                                .songNumber
                                                                .toString(),
                                                          ),
                                                        )),
                                                    TableCell(
                                                        verticalAlignment:
                                                            TableCellVerticalAlignment
                                                                .middle,
                                                        child: Center(
                                                          child: Text(responses[
                                                                  selectedIndex]
                                                              .tracks[i]
                                                              .title),
                                                        )),
                                                    TableCell(
                                                        verticalAlignment:
                                                            TableCellVerticalAlignment
                                                                .middle,
                                                        child: Center(
                                                          child: Text(responses[
                                                                  selectedIndex]
                                                              .tracks[i]
                                                              .length),
                                                        )),
                                                    TableCell(
                                                        verticalAlignment:
                                                            TableCellVerticalAlignment
                                                                .middle,
                                                        child: Center(
                                                          child: Text(responses[
                                                                  selectedIndex]
                                                              .tracks[i]
                                                              .size),
                                                        )),
                                                    ValueListenableBuilder<int>(
                                                        valueListenable:
                                                            trackIndexSelected,
                                                        builder: (context,
                                                            selectedIndex,
                                                            child) {
                                                          return Visibility(
                                                              visible: i ==
                                                                  selectedIndex,
                                                              child: TableCell(
                                                                verticalAlignment:
                                                                    TableCellVerticalAlignment
                                                                        .middle,
                                                                child: Center(
                                                                  child: MusicBarControl(
                                                                      audioManager:
                                                                          audioManager),
                                                                ),
                                                              ));
                                                        }),
                                                    TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child:
                                                          AudioControlButtons(
                                                        rowIndex: i,
                                                        audioManager:
                                                            audioManager,
                                                        audioUrl: responses[
                                                                selectedIndex]
                                                            .tracks[i]
                                                            .url,
                                                        onPlayPressed:
                                                            (rowIndex) {
                                                          audioManager.setTotalTrackLength(
                                                              stringToSeconds(responses[
                                                                              selectedIndex]
                                                                          .tracks[
                                                                              i]
                                                                          .length)
                                                                      .toDouble() *
                                                                  1000);
                                                          // Llama a la función de devolución de llamada cuando se presiona "play"
                                                          trackIndexSelected
                                                                  .value =
                                                              rowIndex; // Actualiza el índice de fila seleccionado
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                          child: Text(widget.appLocalizations.cancel),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class MusicBarControl extends StatefulWidget {
  final AudioManager audioManager;

  const MusicBarControl({super.key, required this.audioManager});
  @override
  _MusicBarControlState createState() => _MusicBarControlState();
}

class _MusicBarControlState extends State<MusicBarControl> {
  double _currentPosition = 0.0;
  double _totalDuration = 0.0;

  @override
  void initState() {
    super.initState();

    // Listening to playback position events
    widget.audioManager.audioPlayer.onPositionChanged
        .listen((Duration duration) {
      widget.audioManager.currentTrackPosition.value =
          duration.inMilliseconds.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
        valueListenable: widget.audioManager.currentTrackPosition,
        builder: (context, currentTrackPosition, child) {
          return ValueListenableBuilder<double>(
            valueListenable: widget.audioManager.totalTrackLength,
            builder: (context, totalTrackLength, child) {
              // Song progress bar
              return SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    // Personaliza el tamaño de la esfera aquí
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 5.0, elevation: 0.2),
                  ),
                  child: Slider(
                    value: currentTrackPosition,
                    min: 0.0,
                    max: totalTrackLength,
                    onChanged: (value) {
                      // Adjusts the playback position when the user drags the progress bar
                      widget.audioManager.audioPlayer
                          .seek(Duration(milliseconds: value.toInt()));
                    },
                  ));
            },
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AudioControlButtons extends StatefulWidget {
  final String audioUrl;
  final AudioManager audioManager;
  final int rowIndex;

  final void Function(int) onPlayPressed;

  AudioControlButtons({
    required this.audioUrl,
    required this.audioManager,
    required this.rowIndex,
    required this.onPlayPressed,
  });

  @override
  _AudioControlButtonsState createState() => _AudioControlButtonsState();
}

class _AudioControlButtonsState extends State<AudioControlButtons> {
  @override
  void initState() {
    super.initState();

    // Listen to the song ending event
    listenAudioCompletion();
  }

  @override
  Widget build(BuildContext context) {
    String mp3Play = '';
    final appState = Provider.of<AppState>(context);
    return ValueListenableBuilder<String>(
      valueListenable: widget.audioManager.currentUrlNotifier,
      builder: (context, currentUrl, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: widget.audioManager.isPlayingNotifier,
          builder: (context, isPlaying, child) {
            bool isCurrentUrl = (widget.audioUrl == currentUrl);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButtonHoverColored(
                  onPressed: () async {
                    String url = widget.audioUrl;
                    mp3Play = await DioClient().getMp3UrlDownload(url: url);

                    if (isPlaying && url == currentUrl) {
                      // If playing, pause the song
                      widget.audioManager.isPlayingNotifier.value = false;
                      widget.audioManager.pause();
                    } else {
                      // If it is not playing or the URL has changed, play the song
                      if (url != currentUrl) {
                        await widget.audioManager.playUrl(mp3Play);
                        widget.audioManager.isPlayingNotifier.value = true;
                        widget.audioManager.currentUrlNotifier.value =
                            url; // Update the current URL
                        widget.onPlayPressed(widget.rowIndex);
                      } else {
                        widget.audioManager.isPlayingNotifier.value = true;
                        await widget.audioManager
                            .resume(); // If URL did not change, resume playback
                      }
                    }
                  },
                  iconColor: Colors.black,
                  icon: isCurrentUrl
                      ? (isPlaying ? Icons.pause : Icons.play_arrow)
                      : Icons
                          .play_arrow, // Play or Pause according to status and URL
                ),
                IconButtonHoverColored(
                  onPressed: () {
                    widget.audioManager.stop();

                    // Update the status of the button to "play" if it is the current URL.
                    if (isCurrentUrl) {
                      widget.audioManager.currentUrlNotifier.value = '';
                    }
                  },
                  iconColor: Colors.black,
                  icon: Icons.stop,
                ),
                IconButtonHoverColored(
                  onPressed: () async {
                    String id = appState.selectedGame?.media.screenshots
                            .split('_')[0] ??
                        '';
                    String url = widget.audioUrl;
                    mp3Play = await DioClient().getMp3UrlDownload(url: url);
                    int? mediaId = appState.selectedGame?.media.id;
                    String audioFolder = '\\Synchronyx\\media\\audio\\$id\\';
                    String audioName = '${id}_ost.mp3';
                    downloadAndSaveAudioOst(mp3Play, audioName, audioFolder);
                    updateOstInMedia(audioName, mediaId);
                    Navigator.of(context).pop();
                    widget.audioManager.currentUrlNotifier.value = '';
                    widget.audioManager.isPlayingNotifier.value = false;
                    widget.audioManager.stop();
                    appState.updateSelectedGameOst(audioName);
                  },
                  iconColor: Colors.black,
                  icon: Icons.file_download,
                ),
              ],
            );
          },
        );
      },
    );
  }

  void listenAudioCompletion() async {
    // Escuchar el evento de finalización de la canción
    widget.audioManager.audioPlayer.onPlayerComplete.listen((event) {
      widget.audioManager.currentUrlNotifier.value = '';
      widget.audioManager.isPlayingNotifier.value = false;
    });
  }
}
