// albums_tab.dart
import 'package:flutter/material.dart';

import '../models/album.dart';

class AlbumsTab extends StatelessWidget {
  final List<Album> albums;
  final Function(String) onPlay;

  AlbumsTab({required this.albums, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return _buildAlbumList(albums);
  }

  Widget _buildAlbumList(List<Album> items) {
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
