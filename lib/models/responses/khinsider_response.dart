class KhinsiderResponse {
  final String nameAlbum;
  final String? platform;
  final int? year;
  final List<KhinsiderTrackResponse>? tracks;

  KhinsiderResponse({
    required this.nameAlbum,
    this.platform,
    this.year,
    this.tracks,
  });
}

class KhinsiderTrackResponse {
  final int songNumber;
  final String title;
  final String? length;
  final String? size;

  KhinsiderTrackResponse({
    required this.songNumber,
    required this.title,
    this.length,
    this.size,
  });
}
