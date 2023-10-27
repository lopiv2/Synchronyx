class Event {
  int? id;
  String name;
  String game;
  String? image;
  DateTime releaseDate;
  int dismissed;

  Event({
    this.id,
    required this.name,
    required this.game,
    this.image,
    required this.releaseDate,
    required this.dismissed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'game': game,
      'image': image,
      'releaseDate': releaseDate.toIso8601String(),
      'dismissed': dismissed,
    };
  }

  @override
  String toString() {
    return 'Event{id: $id, game: $game, name: $name, image: $image, releaseDate: $releaseDate,dismissed: $dismissed}';
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        game: map['game'] ?? '',
        image: map['image'],
        dismissed: map['dismissed'] ?? 0,
        releaseDate: DateTime.parse(map['releaseDate']));
  }
}
