// songs_tab.dart
import 'package:flutter/material.dart';
import 'package:top_tracks/models/track.dart';

class SongsTab extends StatelessWidget {
  final List<Track> tracks;
  final Function(String) onPlay;

  SongsTab({required this.tracks, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return _buildTrackList(tracks);
  }

  Widget _buildTrackList(List<Track> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text(item.artist),
          trailing: IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () => onPlay(item.spotifyUrl),
          ),
        );
      },
    );
  }
}
