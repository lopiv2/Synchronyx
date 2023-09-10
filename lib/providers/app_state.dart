import 'package:flutter/material.dart';
import 'package:synchronyx/models/global_options.dart';
import 'package:synchronyx/models/responses/gameMedia_response.dart';

class AppState extends ChangeNotifier {
  GameMediaResponse? selectedGame;
  late GlobalOptions selectedOptions; //Current using options
  late GlobalOptions optionsResponse; //Temporary Response for options until saved
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
  bool _showMoreContent = false;
  bool get showMoreContent => _showMoreContent;
  final ValueNotifier<String> selectedOptionClicked = ValueNotifier<String>('');//Option selected in the options menu to display one menu or the other.

  //Show more tracks in ost import dialog
  void toggleShowMoreContent() {
    _showMoreContent = !_showMoreContent;
    notifyListeners();
  }

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

  void updateSelectedGameOst(String musicUrl) {
    selectedGame?.media.musicUrl = musicUrl;
    notifyListeners();
  }

  void updateSelectedGame(GameMediaResponse? game) {
    selectedGame = game;
    notifyListeners();
  }

  void refreshGridView() {
    shouldRefreshGridView = !shouldRefreshGridView;
    print("refresh");
    notifyListeners();
  }

  void updateGamesInGrid() {
    notifyListeners();
  }
}
