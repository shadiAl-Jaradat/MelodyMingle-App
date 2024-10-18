import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/presentation/screens/artists_screen.dart';
import 'package:music_player_app/presentation/screens/favourite_screen.dart';
import 'package:music_player_app/presentation/screens/home_screen.dart';
import 'package:music_player_app/presentation/screens/now_playing_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
    getPages: [
      GetPage(name: '/', page: () => HomeScreen()),
      GetPage(name: '/now_playing', page: () => const NowPlayingScreen()),
      GetPage(name: '/personal_settings', page: () => const FavouriteScreen()),
      GetPage(name: '/podcast', page: () => ArtistsScreen(onTap: () {})),
    ],
  ));
}
