class Media {
  int? id;
  String backgroundImageUrl;
  String backImageUrl;
  String coverImageUrl;
  String diskImageUrl;
  String iconUrl;
  String logoUrl;
  String marqueeUrl;
  String musicUrl;
  String name;
  String screenshots;
  String videoUrl;

  Media({
    this.backgroundImageUrl = '',
    this.backImageUrl = '',
    this.coverImageUrl = '',
    this.diskImageUrl = '',
    this.iconUrl = '',
    this.id,
    this.logoUrl = '',
    this.marqueeUrl = '',
    this.musicUrl = '',
    this.name = '',
    this.screenshots = '',
    this.videoUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'coverImageUrl': coverImageUrl,
      'backImageUrl': backImageUrl,
      'diskImageUrl': diskImageUrl,
      'backgroundImageUrl': backgroundImageUrl,
      'videoUrl': videoUrl,
      'marqueeUrl': marqueeUrl,
      'musicUrl': musicUrl,
      'screenshots': screenshots,
      'iconUrl': iconUrl,
      'logoUrl': logoUrl,
    };
  }

  @override
  String toString() {
    return 'Media{id: $id, name: $name, coverImageUrl: $coverImageUrl,backImageUrl: $backImageUrl, diskImageUrl: $diskImageUrl, backgroundImageUrl: $backgroundImageUrl, videoUrl: $videoUrl, marqueeUrl: $marqueeUrl, musicUrl: $musicUrl,screenshots: $screenshots, iconUrl: $iconUrl, logoUrl: $logoUrl}';
  }

  static Media fromMap(Map<String, dynamic> map) {
    return Media(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      coverImageUrl: map['coverImageUrl'],
      backImageUrl: map['backImageUrl'] ?? '',
      diskImageUrl: map['diskImageUrl'] ?? '',
      backgroundImageUrl: map['backgroundImageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      marqueeUrl: map['marqueeUrl'] ?? '',
      musicUrl: map['musicUrl'] ?? '',
      screenshots: map['screenshots'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
    );
  }
}
