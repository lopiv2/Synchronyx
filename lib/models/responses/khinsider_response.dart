class KhinsiderResponse {
  final String nameAlbum;
  final String? platform;
  final int? year;
  final List<KhinsiderTrackResponse> tracks;

  KhinsiderResponse({
    required this.nameAlbum,
    this.platform,
    this.year,
    List<KhinsiderTrackResponse>?
        tracks, // Puedes proporcionar una lista opcional en el constructor
  }) : tracks = tracks ?? [];
}

class KhinsiderTrackResponse {
  final int songNumber;
  final String title;
  final String length;
  final String size;
  final String url;

  KhinsiderTrackResponse({
    required this.songNumber,
    required this.title,
    this.length='0',
    this.size='0',
    this.url='0',
  });
}
