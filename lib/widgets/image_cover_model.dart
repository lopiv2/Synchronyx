import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:synchronyx/utilities/generic_api_functions.dart';
import '../models/game.dart';
import '../models/responses/gameMedia_response.dart';
import '../models/media.dart';
import '../providers/app_state.dart';

class ImageCoverModel extends StatefulWidget {
  final Game game;
  final Media gameMedia;
  final int index;
  final Function(int) onGameClick;

  const ImageCoverModel(
      {super.key,
      required this.game,
      required this.gameMedia,
      required this.index,
      required this.onGameClick});

  @override
  _ImageCoverModel createState() => _ImageCoverModel();
}

class _ImageCoverModel extends State<ImageCoverModel>
    with SingleTickerProviderStateMixin {
  bool isMouseOver = false;
  DioClient dioClient = DioClient();
  late AnimationController _animationController;
  bool isRotated = false;
  bool rotatedCover = false;
  bool showAdditionalOverlay =
      false; // Variable para controlar la visibilidad de la imagen overlay adicional

  void toggleCoverAnimation(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.toggleCover();
  }

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    //Compruebo para que solo rote el elemento con indice clickado
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    ImageProvider<Object> logoWidgetMarquee;
    logoWidgetMarquee = FileImage(File(widget.gameMedia.logoUrl));
    if (widget.index == appState.clickedElementIndex) {
      //If the animation of the element is enabled to be performed
      if (Provider.of<AppState>(context, listen: false)
          .elementsAnimations[widget.index]) {
        _animationController.forward();
        _animationController.addListener(() {
          // Detect when the animation has finished and change the state of showAdditionalOverlay
          if (_animationController.value > 0.5) {
            setState(() {
              showAdditionalOverlay = true;
            });
          } else if (_animationController.status == AnimationStatus.dismissed) {
            setState(() {
              showAdditionalOverlay = false;
            });
          }
          if (_animationController.status == AnimationStatus.completed) {
            //_animationController.reverse();
            appState.elementsAnimations[widget.index] = false;
          }
        });
      }
    } else {
      _animationController.stop();
    }

    return Stack(children: [
      appState.selectedOptions.twoDThreeDCovers == 1
          ? ThreeDGameCover(
              animationController: _animationController,
              index: widget.index,
              onGameClick: widget.onGameClick,
              game: widget.game,
              gameMedia: widget.gameMedia,
              showAdditionalOverlay: showAdditionalOverlay,
            )
          : TwoDGameCover(
              animationController: _animationController,
              index: widget.index,
              onGameClick: widget.onGameClick,
              game: widget.game,
              gameMedia: widget.gameMedia,
              showAdditionalOverlay: showAdditionalOverlay),
      //If the logo is not displayed but the title is displayed
      appState.selectedOptions.showLogoNameOnGrid == 0
          ? Positioned(
              top: MediaQuery.of(context).size.width * 0.095,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.game.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.0,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                        appState.selectedOptions.showEditorOnGrid == 1
                            ? Text(
                                widget.game.developer.split(',')[0],
                                style: TextStyle(
                                  color: Color.fromARGB(255, 192, 218, 231),
                                  fontSize: 5.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                softWrap: true,
                              )
                            : Text(""),
                      ])))
          : Positioned(
              top: MediaQuery.of(context).size.width * 0.093,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.03,
                        height: MediaQuery.of(context).size.height * 0.03,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: logoWidgetMarquee,
                            fit: BoxFit.scaleDown,
                          ),
                        )),
                    appState.selectedOptions.showEditorOnGrid == 1
                        ? Text(
                            widget.game.developer.split(',')[0],
                            style: TextStyle(
                              color: Color.fromARGB(255, 192, 218, 231),
                              fontSize: 5.0,
                              fontWeight: FontWeight.normal,
                            ),
                            softWrap: true,
                          )
                        : Text(""),
                  ]),
            ),
    ]);
  }
}

class ThreeDGameCover extends StatelessWidget {
  final AnimationController animationController;
  final int index;
  final Function(int) onGameClick;
  final Game game;
  final Media gameMedia;
  final bool showAdditionalOverlay;

  const ThreeDGameCover(
      {super.key,
      required this.animationController,
      required this.index,
      required this.onGameClick,
      required this.game,
      required this.gameMedia,
      required this.showAdditionalOverlay});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    ImageProvider<Object> imageWidgetFront;
    if (gameMedia.coverImageUrl.isNotEmpty) {
      imageWidgetFront = FileImage(File(gameMedia.coverImageUrl));
    } else {
      imageWidgetFront = const AssetImage('assets/images/noImage.png');
    }
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0018) // Aplicar una perspectiva 3D
              ..rotateX(0.2) // Rotación en el eje x
              ..rotateY(index == appState.clickedElementIndex &&
                      appState.elementsAnimations[index]
                  ? animationController.value * 3.45
                  : 0.4), // Rotación en el eje y (45 grados si el ratón está sobre el widget, 0 grados si no)
            child: Stack(
              children: [
                Image.asset(
                  'assets/models/PS2WII.png',
                  //color: Colors.red,
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  fit: BoxFit.contain,
                ),
                Positioned.fill(
                  left: 0,
                  bottom: 0,
                  child: Transform.scale(
                    scale: 0.395,
                    child: Container(
                      height: 100,
                      width: 3000,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        elevation: 8.0,
                        onPressed: () {
                          onGameClick(game.id!);
                          GameMediaResponse gameMediaResponse =
                              GameMediaResponse.fromGameAndMedia(
                                  game, gameMedia);
                          createGameFromTitle(gameMediaResponse, appState);
                        },
                        child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2,
                                0.0018) // Aplicar una perspectiva 3D adicional a la imagen overlay
                            ..rotateX(
                                0) // Rotación en el eje x de la imagen overlay (15 grados si el ratón está sobre el widget, 0 grados si no)
                            ..rotateY(
                                0), // Rotación en el eje y de la imagen overlay (60 grados si el ratón está sobre el widget, 0 grados si no)
                          alignment: Alignment.center,
                          child: AspectRatio(
                            aspectRatio: 8.5 / 12,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageWidgetFront,
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Visibility(
                    visible: showAdditionalOverlay,
                    child: Transform.scale(
                      scale:
                          0.395, // Ajusta el tamaño del botón (50% en este ejemplo)
                      child: Container(
                        height: 100, //height of button
                        width:
                            3000, // Ancho deseado del botón (puedes ajustarlo según tus necesidades)
                        child: MaterialButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          splashColor: Colors.red,
                          elevation: 8.0,
                          onPressed: () {},
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2,
                                  0.0018) // Aplicar una perspectiva 3D adicional a la imagen overlay
                              ..rotateX(
                                  0) // Rotación en el eje x de la imagen overlay (15 grados si el ratón está sobre el widget, 0 grados si no)
                              ..rotateY(
                                  pi), // Rotación en el eje y de la imagen overlay (60 grados si el ratón está sobre el widget, 0 grados si no)
                            alignment: Alignment.center,
                            child: AspectRatio(
                              aspectRatio: 8 / 12,
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/backcover.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void createGameFromTitle(GameMediaResponse game, AppState appState) {
    appState.updateSelectedGame(game);
    //print(appState.selectedGame);
  }
}

class TwoDGameCover extends StatelessWidget {
  final AnimationController animationController;
  final int index;
  final Function(int) onGameClick;
  final Game game;
  final Media gameMedia;
  final bool showAdditionalOverlay;

  const TwoDGameCover(
      {super.key,
      required this.animationController,
      required this.index,
      required this.onGameClick,
      required this.game,
      required this.gameMedia,
      required this.showAdditionalOverlay});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    ImageProvider<Object> imageWidgetFront;
    if (gameMedia.coverImageUrl.isNotEmpty) {
      imageWidgetFront = FileImage(File(gameMedia.coverImageUrl));
    } else {
      imageWidgetFront = const AssetImage('assets/images/noImage.png');
    }
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
              child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(1, 2, 0.0018) // Aplicar una perspectiva 3D
              ..rotateX(0) // Rotación en el eje x
              ..rotateY(index == appState.clickedElementIndex &&
                      appState.elementsAnimations[index]
                  ? animationController.value * 3.45
                  : 0.4), // Rotación en el eje y (45 grados si el ratón está sobre el widget, 0 grados si no)
            child: Stack(
              children: [
                Positioned.fill(
                  left: 0,
                  bottom: 0,
                  child: Transform.scale(
                    scale: 0.400,
                    child: MaterialButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      splashColor: Colors.red,
                      elevation: 8.0,
                      onPressed: () {
                        onGameClick(game.id!);
                        GameMediaResponse gameMediaResponse =
                            GameMediaResponse.fromGameAndMedia(game, gameMedia);
                        createGameFromTitle(gameMediaResponse, appState);
                      },
                      child: AspectRatio(
                        aspectRatio: 8.5 / 12,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                              image: imageWidgetFront,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Visibility(
                    visible: showAdditionalOverlay,
                    child: Transform.scale(
                      scale:
                          0.400, // Ajusta el tamaño del botón (50% en este ejemplo)
                      child: Container(
                        height: 100, //height of button
                        width:
                            3000, // Ancho deseado del botón (puedes ajustarlo según tus necesidades)
                        child: MaterialButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          splashColor: Colors.red,
                          elevation: 8.0,
                          onPressed: () {},
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2,
                                  0.0018) // Aplicar una perspectiva 3D adicional a la imagen overlay
                              ..rotateX(
                                  0) // Rotación en el eje x de la imagen overlay (15 grados si el ratón está sobre el widget, 0 grados si no)
                              ..rotateY(
                                  pi), // Rotación en el eje y de la imagen overlay (60 grados si el ratón está sobre el widget, 0 grados si no)
                            alignment: Alignment.center,
                            child: AspectRatio(
                              aspectRatio: 8 / 12,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/backcover.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }

  void createGameFromTitle(GameMediaResponse game, AppState appState) {
    appState.updateSelectedGame(game);
    //print(appState.selectedGame);
  }
}
