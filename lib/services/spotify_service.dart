// lib/services/spotify_service.dart
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:top_tracks/models/track.dart';

class SpotifyService {
  final _storage = const FlutterSecureStorage();

  // Fetch the access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Fetch top tracks from Spotify API
  Future<List<Track>> getTopTracks(String timeRange) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception("No access token found");
    }

    final response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/me/top/tracks?time_range=$timeRange&limit=20',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['items'];
      return data.map((trackData) => Track.fromJson(trackData)).toList();
    } else {
      throw Exception('Failed to load top tracks');
    }
  }
}
