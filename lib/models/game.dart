class Game {
  int id;
  String title;
  String description;
  String boxColor;
  int mediaId;
  String platform;
  List<String> genres;
  int maxPlayers;
  String developer;
  String publisher;
  String region;
  String file;
  int releaseYear;
  double rating;
  bool favorite;
  int playTime;
  DateTime lastPlayed;
  List<String> tags;

  Game({
    required this.id,
    required this.title,
    required this.description,
    this.boxColor = '',
    this.mediaId = 0,
    this.platform = '',
    this.genres = const [],
    this.maxPlayers = 1,
    this.developer = '',
    this.publisher = '',
    this.region = '',
    this.file = '',
    this.releaseYear = 0,
    this.rating = 0.0,
    this.favorite = false,
    this.playTime = 0,
    required this.lastPlayed,
    this.tags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'boxColor': boxColor,
      'mediaId': mediaId,
      'platform': platform,
      'genres': genres,
      'maxPlayers': maxPlayers,
      'developer': developer,
      'publisher': publisher,
      'region': region,
      'file': file,
      'releaseYear': releaseYear,
      'rating': rating,
      'favorite': favorite,
      'playTime': playTime,
      'lastPlayed': lastPlayed.toLocal(),
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'Game{id: $id, title: $title, description: $description,boxColor: $boxColor, mediaId: $mediaId, platform: $platform, genres: $genres, maxPlayers: $maxPlayers, developer: $developer, publisher: $publisher, region: $region, file: $file, releaseYear: $releaseYear, rating: $rating, favorite: $favorite, playTime: $playTime, lastPlayed: $lastPlayed, tags: $tags}';
  }
}
