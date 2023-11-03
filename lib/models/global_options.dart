class GlobalOptions {
  int? id;
  late int twoDThreeDCovers;
  late int playOSTOnSelectGame;
  late int showLogoNameOnGrid;
  late int showEditorOnGrid;
  late String logoAnimation;
  late int showBackgroundImageCalendar;
  late int hoursAdvanceNotice; //Hours of advance notice of events
  String? imageBackgroundFile;
  late String selectedTheme;

  GlobalOptions({
    this.id,
    required this.twoDThreeDCovers,
    required this.playOSTOnSelectGame,
    required this.showLogoNameOnGrid,
    required this.showEditorOnGrid,
    required this.logoAnimation,
    required this.hoursAdvanceNotice,
    required this.showBackgroundImageCalendar,
    this.imageBackgroundFile,
    required this.selectedTheme,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'twoDThreeDCovers': twoDThreeDCovers,
      'playOSTOnSelectGame': playOSTOnSelectGame,
      'showLogoNameOnGrid': showLogoNameOnGrid,
      'showEditorOnGrid': showEditorOnGrid,
      'logoAnimation': logoAnimation,
      'hoursAdvanceNotice': hoursAdvanceNotice,
      'showBackgroundImageCalendar': showBackgroundImageCalendar,
      'imageBackgroundFile': imageBackgroundFile,
      'selectedTheme':selectedTheme,
    };
  }

  // Copy Builder
  GlobalOptions.copy(GlobalOptions other) {
    id = other.id;
    twoDThreeDCovers = other.twoDThreeDCovers;
    playOSTOnSelectGame = other.playOSTOnSelectGame;
    showLogoNameOnGrid = other.showLogoNameOnGrid;
    showEditorOnGrid = other.showEditorOnGrid;
    logoAnimation = other.logoAnimation;
    hoursAdvanceNotice = other.hoursAdvanceNotice;
    showBackgroundImageCalendar = other.showBackgroundImageCalendar;
    imageBackgroundFile = other.imageBackgroundFile;
    selectedTheme=other.selectedTheme;
  }

  @override
  String toString() {
    return 'Options{id: $id, twoDThreeDCovers: $twoDThreeDCovers,playOSTOnSelectGame: $playOSTOnSelectGame, showLogoNameOnGrid: $showLogoNameOnGrid, showEditorOnGrid: $showEditorOnGrid, logoAnimation: $logoAnimation, hoursAdvanceNotice: $hoursAdvanceNotice, showBackgroundImageCalendar=$showBackgroundImageCalendar,selectedTheme=$selectedTheme}';
  }

  static GlobalOptions fromMap(Map<String, dynamic> map) {
    return GlobalOptions(
      id: map['id'] ?? '',
      twoDThreeDCovers: map['twoDThreeDCovers'] ?? '1',
      playOSTOnSelectGame: map['playOSTOnSelectGame'] ?? '1',
      showLogoNameOnGrid: map['showLogoNameOnGrid'] ?? '1',
      showEditorOnGrid: map['showEditorOnGrid'] ?? '1',
      hoursAdvanceNotice: map['hoursAdvanceNotice'] ?? '48',
      logoAnimation: map['logoAnimation'] ?? 'FadeInDown',
      showBackgroundImageCalendar: map['showBackgroundImageCalendar'] ?? '0',
      imageBackgroundFile: map['imageBackgroundFile'] ?? '',
      selectedTheme: map['selectedTheme'] ?? 'Slime World',
    );
  }
}
