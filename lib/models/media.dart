class Media {
  int? id;
  String name;
  String coverImageUrl;
  String backImageUrl;
  String diskImageUrl;
  String backgroundImageUrl;
  String videoUrl;
  String marqueeUrl;
  String screenshots;
  String iconUrl;
  String logoUrl;

  Media({
    this.id,
    this.name = '',
    this.coverImageUrl = '',
    this.backImageUrl = '',
    this.diskImageUrl = '',
    this.backgroundImageUrl = '',
    this.videoUrl = '',
    this.marqueeUrl = '',
    this.screenshots = '',
    this.iconUrl = '',
    this.logoUrl = '',
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
      'screenshots': screenshots,
      'iconUrl': iconUrl,
      'logoUrl': logoUrl,
    };
  }

  @override
  String toString() {
    return 'Media{id: $id, name: $name, coverImageUrl: $coverImageUrl,backImageUrl: $backImageUrl, diskImageUrl: $diskImageUrl, backgroundImageUrl: $backgroundImageUrl, videoUrl: $videoUrl, marqueeUrl: $marqueeUrl,screenshots: $screenshots, iconUrl: $iconUrl, logoUrl: $logoUrl}';
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
      screenshots: map['screenshots'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
    );
  }
}
