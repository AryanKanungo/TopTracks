import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_tracks/services/auth_service.dart';
import 'package:top_tracks/services/spotify_service.dart'; // Ensure the correct import for SpotifyService

class AppDrawer extends StatelessWidget {
  final String timeRange;
  final Function(String) onTimeRangeChanged;
  final Function(String)
  onPlaylistDeleted; // Callback to handle playlist deletion messages

  const AppDrawer({
    Key? key,
    required this.timeRange,
    required this.onTimeRangeChanged,
    required this.onPlaylistDeleted, // Add the callback for playlist deletion
  }) : super(key: key);

  // Function to delete all playlists
  void _deleteAllPlaylists(BuildContext context) async {
    try {
      // Delete all playlists
      await SpotifyService().deleteAllPlaylists();
      onPlaylistDeleted('All Playlists Deleted Successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All Playlists Deleted Successfully!')),
      );
    } catch (e) {
      onPlaylistDeleted('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> _timeLabels = {
      'short_term': 'This Week',
      'medium_term': 'Last 6 Months',
      'long_term': 'All Time',
    };

    final accentGreen = Color(0xFF1DB954);
    final greyText = Colors.white70;

    return Drawer(
      backgroundColor: Color(0xFF121212), // Dark background for contrast
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentGreen.withOpacity(0.8), accentGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.music_note_rounded, color: Colors.white, size: 45),
                SizedBox(height: 12),
                Text(
                  "TopTracks",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Time Range Selector Title
          ListTile(
            title: Text(
              "Select Time Range",
              style: GoogleFonts.roboto(
                color: greyText,
                fontWeight: FontWeight.w600,
              ),
            ),
            dense: true,
          ),
          // Radio List for Time Range Selection
          ..._timeLabels.entries.map((entry) {
            return RadioListTile<String>(
              activeColor: accentGreen,
              tileColor: Colors.transparent,
              title: Text(
                entry.value,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
              ),
              value: entry.key,
              groupValue: timeRange,
              onChanged: (String? value) {
                if (value != null) {
                  onTimeRangeChanged(value);
                  Navigator.pop(context); // Close drawer
                }
              },
            );
          }).toList(),
          Divider(color: Colors.white24, thickness: 0.5),
          // Delete All Playlists Button
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.redAccent),
            title: Text(
              "Delete All Playlists",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              _deleteAllPlaylists(
                context,
              ); // Call the function to delete all playlists
              Navigator.pop(context); // Close drawer
            },
          ),
          Divider(color: Colors.white24, thickness: 0.5),
          // Logout Button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text(
              "Logout",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () async {
              final AuthService _authService = AuthService();
              await _authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
