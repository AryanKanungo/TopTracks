import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_tracks/services/spotify_service.dart'; // Ensure the correct import for SpotifyService

class GeneratePlaylistModal extends StatefulWidget {
  final Function(String) onPlaylistCreated;

  GeneratePlaylistModal({required this.onPlaylistCreated});

  @override
  _GeneratePlaylistModalState createState() => _GeneratePlaylistModalState();
}

class _GeneratePlaylistModalState extends State<GeneratePlaylistModal> {
  String _selectedTimeRange = 'short_term'; // Initialize as 'short_term'
  String _modalMessage = '';

  // Function to create playlist based on selected time range
  void _createPlaylist() async {
    try {
      // Creating a playlist with the selected time range and top 50 tracks
      await SpotifyService().createPlaylist(_selectedTimeRange, 50);
      setState(() {
        _modalMessage = 'Playlist Created Successfully!';
      });
      widget.onPlaylistCreated('Playlist Created Successfully!');
    } catch (e) {
      widget.onPlaylistCreated('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBg = Color(0xFF121212); // Dark background
    final darkCard = Color(0xFF1F1F1F); // Dark card color
    final accentGreen = Color(0xFF1DB954); // Accent green for buttons
    final greyText = Colors.white70; // Grey text color for non-primary text

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Generate Playlist',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),

          // Time range selection (short_term, medium_term, long_term)
          Column(
            children: [
              RadioListTile<String>(
                value: 'short_term',
                groupValue: _selectedTimeRange,
                onChanged: (value) {
                  setState(() {
                    _selectedTimeRange = value!;
                  });
                },
                title: Text(
                  'Last 4 Weeks',
                  style: GoogleFonts.roboto(
                    color: greyText, // Color of the text
                    fontWeight:
                        FontWeight
                            .w500, // Slightly bolder text for better readability
                    fontSize: 16, // Set a consistent font size
                  ),
                ),
                activeColor:
                    accentGreen, // Accent color for the selected radio button
                toggleable:
                    true, // Make the radio button toggleable (allow unselecting)
              ),
              SizedBox(height: 8), // Adding spacing between radio tiles
              RadioListTile<String>(
                value: 'medium_term',
                groupValue: _selectedTimeRange,
                onChanged: (value) {
                  setState(() {
                    _selectedTimeRange = value!;
                  });
                },
                title: Text(
                  'Last 6 Months',
                  style: GoogleFonts.roboto(
                    color: greyText,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                activeColor: accentGreen,
                toggleable: true,
              ),
              SizedBox(height: 8),
              RadioListTile<String>(
                value: 'long_term',
                groupValue: _selectedTimeRange,
                onChanged: (value) {
                  setState(() {
                    _selectedTimeRange = value!;
                  });
                },
                title: Text(
                  'All Time',
                  style: GoogleFonts.roboto(
                    color: greyText,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                activeColor: accentGreen,
                toggleable: true,
              ),
            ],
          ),

          SizedBox(height: 16),

          // Create button
          Center(
            child: ElevatedButton(
              onPressed: _createPlaylist,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Text(
                'Create',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Display message after creating the playlist
          if (_modalMessage.isNotEmpty) ...[
            SizedBox(height: 10),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                _modalMessage,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
