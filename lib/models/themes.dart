class Themes {
  int? id;
  String name;
  String sideBarColor;
  String backgroundStartColor;
  String backgroundMediumColor;
  String backgroundEndColor;
  String backendFont;

  Themes({
    this.id,
    required this.name,
    required this.sideBarColor,
    required this.backgroundStartColor,
    required this.backgroundMediumColor,
    required this.backgroundEndColor,
    required this.backendFont,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sideBarColor': sideBarColor,
      'backgroundStartColor': backgroundStartColor,
      'backgroundMediumColor': backgroundMediumColor,
      'backgroundEndColor': backgroundEndColor,
      'backendFont': backendFont,
    };
  }

  @override
  String toString() {
    return 'Theme{id: $id, sideBarColor: $sideBarColor, name: $name, backgroundStartColor: $backgroundStartColor,backgroundMediumColor:$backgroundMediumColor, backgroundEndColor: $backgroundEndColor, backendFont:$backendFont}';
  }

  static Themes fromMap(Map<String, dynamic> map) {
    return Themes(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        sideBarColor: map['sideBarColor'] ?? '',
        backgroundStartColor: map['backgroundStartColor'],
        backgroundMediumColor: map['backgroundMediumColor'],
        backgroundEndColor: map['backgroundEndColor'],
        backendFont: map['backendFont']);
  }
}
