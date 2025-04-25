class Artist {
  final String name;
  final String imageUrl;
  final String spotifyUrl;

  Artist({
    required this.name,
    required this.imageUrl,
    required this.spotifyUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      imageUrl: json['images'][0]['url'],
      spotifyUrl: json['external_urls']['spotify'],
    );
  }
}
