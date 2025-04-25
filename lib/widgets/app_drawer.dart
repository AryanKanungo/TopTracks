import 'package:flutter/material.dart';
import 'package:top_tracks/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final String timeRange;
  final Function(String) onTimeRangeChanged;

  const AppDrawer({
    Key? key,
    required this.timeRange,
    required this.onTimeRangeChanged,
  }) : super(key: key);

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
      backgroundColor: Color(0xFF1F1F1F),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentGreen.withOpacity(0.9), accentGreen],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.music_note_rounded, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  "TopTracks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              "Select Time Range",
              style: TextStyle(color: greyText, fontWeight: FontWeight.w500),
            ),
            dense: true,
          ),
          ..._timeLabels.entries.map((entry) {
            return RadioListTile(
              activeColor: accentGreen,
              tileColor: Colors.transparent,
              title: Text(entry.value, style: TextStyle(color: Colors.white)),
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
          Divider(color: Colors.white24),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text("Logout", style: TextStyle(color: Colors.white)),
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
