// lib/models/track.dart

class Track {
  final String name;
  final String artist;
  final String album;
  final String imageUrl;
  final String spotifyUrl; // Added field

  Track({
    required this.name,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.spotifyUrl, // Updated constructor
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'],
      artist:
          json['artists'][0]['name'], // Assuming the first artist in the array
      album: json['album']['name'],
      imageUrl:
          json['album']['images'][0]['url'], // Getting the first image of the album
      spotifyUrl: json['external_urls']['spotify'], // Parsing Spotify URL
    );
  }
}
