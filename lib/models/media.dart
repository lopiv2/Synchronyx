class Media {
  int id;
  int gameId;
  String coverImageUrl;
  String backImageUrl;
  String diskImageUrl;
  String videoUrl;
  String iconUrl;

  Media({
    required this.id,
    required this.gameId,
    this.coverImageUrl = '',
    this.backImageUrl = '',
    this.diskImageUrl = '',
    this.videoUrl = '',
    this.iconUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameId': gameId,
      'coverImageUrl': coverImageUrl,
      'backImageUrl': backImageUrl,
      'diskImageUrl': diskImageUrl,
      'videoUrl': videoUrl,
      'iconUrl': iconUrl,
    };
  }

  @override
  String toString() {
    return 'Media{id: $id, gameId: $gameId, coverImageUrl: $coverImageUrl,backImageUrl: $backImageUrl, diskImageUrl: $diskImageUrl, videoUrl: $videoUrl, iconUrl: $iconUrl}';
  }
}
