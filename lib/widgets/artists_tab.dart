// artists_tab.dart
import 'package:flutter/material.dart';

import '../models/artist.dart';

class ArtistsTab extends StatelessWidget {
  final List<Artist> artists;
  final Function(String) onPlay;

  ArtistsTab({required this.artists, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return _buildArtistList(artists);
  }

  Widget _buildArtistList(List<Artist> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.name),
          leading: Image.network(item.imageUrl),
          onTap: () => onPlay(item.spotifyUrl),
        );
      },
    );
  }
}
