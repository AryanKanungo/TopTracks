class Album {
  final String name;
  final String imageUrl;
  final String spotifyUrl;

  Album({required this.name, required this.imageUrl, required this.spotifyUrl});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      imageUrl: json['images'][0]['url'],
      spotifyUrl: json['external_urls']['spotify'],
    );
  }
}
