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
        'https://api.spotify.com/v1/me/top/tracks?time_range=$timeRange&limit=50', // Increased limit to 50
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

  // Create a playlist with user's top tracks
  Future<void> createPlaylist(String timeRange, int limit) async {
    print("Inside Create Playlist");
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception("No access token found");
    }

    // Step 1: Create a new playlist
    final createPlaylistResponse = await http.post(
      Uri.parse('https://api.spotify.com/v1/me/playlists'),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: json.encode({
        'name': 'TopTracks $timeRange',
        'description': 'Your top $limit tracks from the last $timeRange',
        'public': false,
      }),
    );

    if (createPlaylistResponse.statusCode != 201) {
      throw Exception('Failed to create playlist');
    }

    final playlistId = json.decode(createPlaylistResponse.body)['id'];

    // Step 2: Get the top tracks
    List<Track> topTracks = await getTopTracks(timeRange);

    // Step 3: Add the top tracks to the new playlist
    final trackUris = topTracks.map((track) => track.uri).toList();
    final addTracksResponse = await http.post(
      Uri.parse('https://api.spotify.com/v1/playlists/$playlistId/tracks'),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: json.encode({'uris': trackUris}),
    );

    if (addTracksResponse.statusCode != 201) {
      throw Exception('Failed to add tracks to playlist');
    }
  }

  Future<void> deleteAllPlaylists() async {
    final accessToken = await getAccessToken();
    final url = 'https://api.spotify.com/v1/me/playlists';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      var playlists = jsonDecode(response.body)['items'];
      for (var playlist in playlists) {
        var playlistId = playlist['id'];
        await _deletePlaylist(playlistId, accessToken!);
      }
    } else {
      print("Failed to fetch playlists: ${response.body}");
      throw Exception('Failed to fetch playlists');
    }
  }

  Future<void> _deletePlaylist(String playlistId, String accessToken) async {
    final url = 'https://api.spotify.com/v1/playlists/$playlistId/followers';

    final response = await http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      print("Playlist $playlistId deleted successfully");
    } else {
      print("Failed to delete playlist $playlistId: ${response.body}");
      throw Exception('Failed to delete playlist');
    }
  }
}
