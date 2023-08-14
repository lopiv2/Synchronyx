class Media {
  int id;
  String name;
  String coverImageUrl;
  String backImageUrl;
  String diskImageUrl;
  String videoUrl;
  String iconUrl;
  String logoUrl;

  Media({
    this.id = 0,
    this.name = '',
    this.coverImageUrl = '',
    this.backImageUrl = '',
    this.diskImageUrl = '',
    this.videoUrl = '',
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
      'videoUrl': videoUrl,
      'iconUrl': iconUrl,
      'logoUrl': logoUrl,
    };
  }

  @override
  String toString() {
    return 'Media{id: $id, name: $name, coverImageUrl: $coverImageUrl,backImageUrl: $backImageUrl, diskImageUrl: $diskImageUrl, videoUrl: $videoUrl, iconUrl: $iconUrl, logoUrl: $logoUrl}';
  }

  static Media fromMap(Map<String, dynamic> map) {
    return Media(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      coverImageUrl: map['coverImageUrl'],
      backImageUrl: map['backImageUrl'] ?? '',
      diskImageUrl: map['diskImageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
    );
  }
}
