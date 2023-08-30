import 'package:flutter/material.dart';
import 'package:synchronyx/models/game.dart';
import 'package:synchronyx/models/gameMedia_response.dart';

class AppState extends ChangeNotifier {
  GameMediaResponse? selectedGame;
  List<GameMediaResponse> gamesInGrid = [];
  bool shouldRefreshGridView = false;
  String _isImporting = 'no'; //Three states, no, importing and finished
  Key buttonClickedKey = ValueKey<int>(42);
  String get isImporting => _isImporting;
  int clickedElementIndex = 0;
  List<bool> elementsAnimations = [];
  bool _isCoverRotated = false;
  bool get isCoverRotated => _isCoverRotated;
  String filter = '';
  String filterValue = '';

  void toggleAnimations() {
    for (int x = 0; x < elementsAnimations.length; x++) {
      elementsAnimations[x] = false;
    }
    elementsAnimations[clickedElementIndex] =
        !elementsAnimations[clickedElementIndex];
    notifyListeners();
  }

  void toggleAnimation() {
    elementsAnimations[clickedElementIndex] =
        !elementsAnimations[clickedElementIndex];
    notifyListeners();
  }

  void toggleCover() {
    _isCoverRotated = !_isCoverRotated;
    notifyListeners();
  }

  void setImportingState(String value) {
    _isImporting = value;
    notifyListeners();
  }


  void updateButtonClickedKey(Key k) {
    buttonClickedKey = k;
    notifyListeners();
  }

  void updateFilters(String filter, String value) {
    this.filter = filter;
    filterValue = value;
    notifyListeners();
  }

  void updateSelectedGame(GameMediaResponse? game) {
    selectedGame = game;
    notifyListeners();
  }

  void refreshGridView() {
    shouldRefreshGridView = !shouldRefreshGridView;
    notifyListeners();
  }

  void updateGamesInGrid() {
    notifyListeners();
  }
}
