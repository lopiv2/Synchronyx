import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:lioncade/models/event.dart';
import 'package:lioncade/models/global_options.dart';
import 'package:lioncade/models/responses/gameMedia_response.dart';
import 'package:lioncade/models/responses/rawg_response.dart';
import 'package:lioncade/models/themes.dart';

class AppState extends ChangeNotifier {
  GameMediaResponse? selectedGame;
  late GlobalOptions selectedOptions; //Current using options
  late Themes themeApplied; //Current using theme
  late GlobalOptions
      optionsResponse; //Temporary Response for options until saved
  List<GameMediaResponse> gamesInGrid = [];
  bool shouldRefreshGridView = false;
  String _isImporting = 'no'; //Three states, no, importing and finished
  double importProgress = 0.0;
  String gameBeingImported=''; //Gets the game that is being imported
  Key buttonClickedKey = const ValueKey<int>(42);
  int filterIndex =
      10; //Value to set default set selection filters when changing tables
  String get isImporting => _isImporting;
  int clickedElementIndex = 0;
  bool showLoadingCircleProgress=false;
  List<bool> elementsAnimations = [];
  bool _isCoverRotated = false;
  bool get isCoverRotated => _isCoverRotated;
  String filter = 'owned';
  String filterValue = 'yes';
  bool _showMoreContent = false;
  bool get showMoreContent => _showMoreContent;
  final ValueNotifier<String> selectedOptionClicked = ValueNotifier<String>(
      ''); //Option selected in the options menu to display one menu or the other.

  bool downloading = false; //Downloading a file or not
  String urlDownloading = ""; //Url downloading
  bool get isDownloading => downloading;
  bool resultsEnabled =
      false; //Variable that is activated when there are game search results
  bool searchGameEnabled =
      false; //Variable to be activated when searching for a game to add to the wanted list.
  List<RawgResponse> results = [];
  late RawgResponse
      gameClicked; //Variable to save the game clicked on in the search
  List<CalendarEventData> events = [];
  final EventController eventController = EventController();

  bool enableGameSearchView =
      false; // Variable that activates the preview panel of the game that we will add to favorite

  //Add event to calendar
  void addEvent(CalendarEventData event) {
    events.add(event);
    eventController.add(event);
    notifyListeners();
  }

  void updateTimer(){
    showLoadingCircleProgress=true;
    Future.delayed(Duration(seconds: 3), () {
      // Oculta el CircularProgress
      showLoadingCircleProgress=false;
    });
    notifyListeners();
  }

  //Add all stored events to calendar and get them at program start
  void addAllEvents(List<Event> eventsList) {
    late CalendarEventData event;
    for (Event e in eventsList) {
      event = CalendarEventData(
        date: e.releaseDate,
        title: e.name,
        color: Colors.orangeAccent
      );
      events.add(event);
      //eventController.add(event);
    }
  }

  // This method will update the value of logoAnimation in optionsResponse
  void updateLogoAnimation(String newLogoAnimation) {
    optionsResponse.logoAnimation = newLogoAnimation;
  }

  Future<void> enableGameSearchViewPanel(bool value) async {
    enableGameSearchView = value;
    notifyListeners();
  }

  Future<void> showResults(List<RawgResponse> res, bool value) async {
    resultsEnabled = value;
    results = List.from(res);
    notifyListeners();
  }

  Future<void> resetFilter() async {
    filterIndex = 10;
    notifyListeners();
  }

  Future<void> toggleGameSearch(bool value) async {
    searchGameEnabled = value;
    notifyListeners();
  }

  Future<void> startDownload(String url) async {
    downloading = true;
    urlDownloading = url;
    notifyListeners();
  }

  Future<void> stopDownload() async {
    downloading = false;
    urlDownloading = '';
    notifyListeners();
  }

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

  void setImportingGame(String value) {
    gameBeingImported = value;
    notifyListeners();
  }

  void setImportingProgress(double value) {
    importProgress = value;
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
    //print("refresh");
    notifyListeners();
  }

  void updateGamesInGrid() {
    notifyListeners();
  }
}
