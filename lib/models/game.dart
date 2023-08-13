class Game {
  int id;
  String title;
  String description;
  String boxColor;
  int mediaId;
  String platform;
  String genres; //List of genres joined by commas
  int maxPlayers;
  String developer;
  String publisher;
  String region;
  String file;
  int releaseYear;
  double rating;
  int favorite; //boolean
  int playTime;
  DateTime? lastPlayed = DateTime.now();
  String tags; //List of tags joined by commas also

  Game({
    this.id = 0,
    required this.title,
    this.description = '',
    this.boxColor = '',
    this.mediaId = 0,
    this.platform = '',
    this.genres = '',
    this.maxPlayers = 1,
    this.developer = '',
    this.publisher = '',
    this.region = '',
    this.file = '',
    this.releaseYear = 0,
    this.rating = 0.0,
    this.favorite = 0,
    this.playTime = 0,
    this.lastPlayed,
    this.tags = '',
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
      'lastPlayed': lastPlayed?.toLocal(),
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'Game{id: $id, title: $title, description: $description,boxColor: $boxColor, mediaId: $mediaId, platform: $platform, genres: $genres, maxPlayers: $maxPlayers, developer: $developer, publisher: $publisher, region: $region, file: $file, releaseYear: $releaseYear, rating: $rating, favorite: $favorite, playTime: $playTime, lastPlayed: $lastPlayed, tags: $tags}';
  }
}
