import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_tracks/models/track.dart';
import 'package:top_tracks/services/spotify_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpotifyService _spotifyService = SpotifyService();
  String _timeRange = 'short_term';
  bool _loading = false;
  List<Track> _tracks = [];

  void _fetchTracks(String timeRange) async {
    setState(() => _loading = true);
    try {
      final tracks = await _spotifyService.getTopTracks(timeRange);
      setState(() => _tracks = tracks);
    } catch (e) {
      print("Error: $e");
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _fetchTracks(_timeRange);
  }

  @override
  Widget build(BuildContext context) {
    final darkBg = Color(0xFF121212);
    final darkCard = Color(0xFF1F1F1F);
    final accentGreen = Color(0xFF1DB954);
    final greyText = Colors.white70;

    return Scaffold(
      backgroundColor: darkBg,
      drawer: AppDrawer(
        timeRange: _timeRange,
        onTimeRangeChanged: (newTimeRange) {
          setState(() {
            _timeRange = newTimeRange;
            _fetchTracks(newTimeRange);
          });
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TopTracks",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(decoration: BoxDecoration(color: darkCard)),
      ),
      body: Stack(
        children: [
          // Wave Background
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: darkBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: CustomPaint(painter: _WavePainter()),
            ),
          ),
          // Main content
          _loading
              ? Center(child: CircularProgressIndicator(color: accentGreen))
              : _tracks.isEmpty
              ? Center(
                child: Text(
                  "No tracks available",
                  style: GoogleFonts.roboto(
                    color: greyText,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _tracks.length,
                  itemBuilder: (context, index) {
                    final track = _tracks[index];

                    return AnimatedPadding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        decoration: BoxDecoration(
                          color: darkCard,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              track.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            track.name,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${track.artist} • ${track.album}',
                            style: GoogleFonts.roboto(
                              color: greyText,
                              fontSize: 14,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.play_circle_fill,
                              color: accentGreen,
                              size: 32,
                            ),
                            onPressed: () async {
                              final url = Uri.parse(track.spotifyUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                print('Could not launch $url');
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..quadraticBezierTo(
            size.width * 0.25,
            size.height - 40,
            size.width * 0.5,
            size.height - 30,
          )
          ..quadraticBezierTo(
            size.width * 0.75,
            size.height - 20,
            size.width,
            size.height - 40,
          )
          ..lineTo(size.width, 0)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
