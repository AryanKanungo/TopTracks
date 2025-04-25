import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService(); // Create auth instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Wave background for soothing effect
          Positioned.fill(child: CustomPaint(painter: WavePainter())),

          // Main content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lottie animation for engaging appeal
                  Lottie.asset(
                    'assets/login_animation.json', // Replace with the path to your animation file
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),

                  // App name with larger font size and smooth style
                  Text(
                    'TopTracks',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.6),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),

                  // Brief description with light and modern typography
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        'Discover your top music tracks across various time ranges.\nLogin to get started!',
                        style: GoogleFonts.roboto(
                          color: Colors.white.withOpacity(
                            0.85,
                          ), // Slightly more contrast for better readability
                          fontSize: 20, // Slightly larger font size for impact
                          fontWeight:
                              FontWeight
                                  .w500, // Slightly bolder for better prominence
                          letterSpacing:
                              1.0, // Increased letter spacing for cleaner look
                          height:
                              1.6, // Adjusted line height for better readability
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(
                                0.4,
                              ), // Soft shadow for depth
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Login button with modern, sleek style and animations
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Call Spotify login and navigate to home on success
                        await _authService.authenticateWithSpotify();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      },
                      child: Text(
                        'Login with Spotify',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1DB954), // Spotify green
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ), // Rounded corners
                        ),
                        elevation: 10, // Slight shadow for a floating effect
                        shadowColor: Color(
                          0xFF1DB954,
                        ).withOpacity(0.6), // Subtle shadow effect
                      ),
                    ),
                  ),

                  // Optional: Adding some bottom space for balance
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// WavePainter for the soothing wave background
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.7)
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..lineTo(0, size.height - 60)
          ..quadraticBezierTo(
            size.width / 4,
            size.height - 100,
            size.width / 2,
            size.height - 60,
          )
          ..quadraticBezierTo(
            3 * size.width / 4,
            size.height,
            size.width,
            size.height - 80,
          )
          ..lineTo(size.width, 0)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
