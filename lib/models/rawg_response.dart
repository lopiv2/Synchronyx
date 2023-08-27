class RawgResponse {
  final String imageUrl;
  final String? developer;
  final String? publisher;
  final String? releaseDate;
  final double metacriticInfo; //1 to 5

  RawgResponse({
    this.releaseDate,
    required this.imageUrl,
    required this.metacriticInfo,
    this.developer,
    this.publisher,
  });
}
