// Copyright (c) 2025 AryanKanungo. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/login_screen.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Top Tracks',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData.dark(), // Dark theme for Spotify vibe
      home: LoginScreen(), // Start with login screen
      routes: {
        '/login': (context) => LoginScreen(), // Named route for login
      },
    );
  }
}
