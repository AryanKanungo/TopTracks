import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Secure storage for tokens
  final _storage = const FlutterSecureStorage();

  // Spotify app credentials (keep these safe!)
  final clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
  final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;
  final redirectUri = dotenv.env['REDIRECT_URI']!;

  // Scopes define the permissions your app needs
  final scopes = 'user-top-read';

  // --- Authenticate with Spotify ---
  Future<void> authenticateWithSpotify({bool forceLogin = true}) async {
    try {
      if (forceLogin) {
        // Remove old token if we're forcing re-login
        await logout();
      }

      final existingToken = await _storage.read(key: 'access_token');

      if (existingToken != null && !forceLogin) {
        print("Already authenticated. Token: $existingToken");
        return;
      }

      // Step 1: Open Spotify's login page in browser
      final authUrl =
          'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&scope=$scopes';

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "myapp",
      );
      print("AUTH CALLBACK RESULT: $result");

      print("Redirect result: $result");

      // Extract authorization code
      final Uri uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) throw Exception("Authorization code not found.");

      // Step 2: Exchange code for access token
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      if (response.statusCode != 200) {
        print("Token exchange failed: ${response.body}");
        throw Exception("Failed to get access token");
      }

      final jsonResponse = json.decode(response.body);
      final accessToken = jsonResponse['access_token'];

      if (accessToken == null) {
        throw Exception("Access token not found in response");
      }

      // Store token securely
      await _storage.write(key: 'access_token', value: accessToken);
      print("Access token stored: $accessToken");
    } catch (e) {
      print("Error during Spotify authentication: $e");
      throw Exception("Spotify Authentication Failed");
    }
  }

  // --- Get token for API requests ---
  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: 'access_token');
    print("Retrieved Access Token: $token");
    return token;
  }

  // --- Logout / clear token ---
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    print("Access token cleared.");
  }
}
