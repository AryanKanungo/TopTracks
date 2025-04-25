#  TopTracks - Spotify Insights App

TopTracks is a Flutter-based mobile application that lets users explore their **Top 50 Spotify songs** over different time ranges — **weekly**, **monthly**, and **yearly**. Additionally, users can **generate custom playlists** from their top tracks and save them directly to their Spotify account.

---

##  Features

-  View your Top 50 songs on Spotify
- Filter by time range: Last 4 Weeks, Last 6 Months, All Time
-  Generate a custom playlist from your top songs
-  Secure Spotify Authentication using OAuth2
- Local secure token storage using `flutter_secure_storage`

---

## 📱 Screenshots

<img src="https://github.com/user-attachments/assets/1ba31b1f-845f-4752-beeb-88537e9068b5" width="300" />

<img src="https://github.com/user-attachments/assets/587e80ec-9516-4b12-9dff-859ba1932ec1" width="300" />

<img src="https://github.com/user-attachments/assets/5a15b540-ba4f-4a13-9d88-758f6474aaa3" width="300" />

<img src="https://github.com/user-attachments/assets/78b0251d-7856-4a96-8a27-bdb7c395ff0d" width="300" />


---

##  Tech Stack

- **Flutter** (Cross-platform app development)
- **Spotify Web API** (User data & playlist generation)
- **OAuth2** with `flutter_web_auth_2`
- **Secure token handling** using `flutter_secure_storage`

---

##  Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/AryanKanungo/TopTracks.git
cd TopTracks
```
2. Install Dependencies
```bash
flutter pub get
```
3. Set up Environment Variables
Create a .env file in the root directory:
```ini
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
REDIRECT_URI=myapp://auth
```
4. Run the App
   ```bash
   flutter run
   ```
