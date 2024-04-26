import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/core/controllers.dart';
import 'package:music_player_app/core/spotify_service.dart';
import 'package:music_player_app/models/artist.dart';
import 'package:music_player_app/models/song.dart';
import 'package:music_player_app/screens/all_songs_screen.dart';
import 'package:music_player_app/screens/artists_screen.dart';
import 'package:music_player_app/screens/personal_settings_screen.dart';
import 'package:music_player_app/screens/search_screen.dart';
import 'package:music_player_app/screens/splash_screen.dart';
import 'package:music_player_app/shared_widgets/custom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:music_player_app/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;
  List<Widget> _screens = [];
  Key _artistsScreenKey = UniqueKey();

  AudioPlayerController audioPlayerController = Get.put(AudioPlayerController(currentIndex: 0.obs, song: Rx<Song?>(null)));
  bool loading = true;
  final SpotifyService spotifyService = SpotifyService(Dio());

  Future<bool> getSongsAndPodcasts() async {
    // List<Song> listSongs = await spotifyService.getRecommendations();
    if (audioPlayerController.listOfSongs.isEmpty) {
      List<Song> listSongs = await spotifyService.getRecommendations();
      audioPlayerController.setListOfSongs(listSongs);
    }
    if (audioPlayerController.listOfArtist.isEmpty) {
      List<Artist> listArtist = await spotifyService.getAllArtists();
      audioPlayerController.setListOfArtist(listArtist);
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _buildScreens();
    return FutureBuilder(
        future: loading ? getSongsAndPodcasts() : null,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(color: MyColors.tertiaryColor),
              ),
            );
          }
          if (snapshot.hasData) {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: const Color(0xFF222932),
                    child: SafeArea(
                        child: IndexedStack(
                      index: tabIndex,
                      children: _screens,
                    )),
                  ),
                  // Add other widgets and features as required
                ],
              ),
              bottomNavigationBar: CustomTabBar(
                onTabChange: (index) {
                  if (index == 3) {
                    // Force rebuild of the ArtistsScreen when it's selected
                    _artistsScreenKey = UniqueKey();
                  }
                  setState(() {
                    tabIndex = index;
                  });
                },
              ),
            );
          }
          return const SplashScreen();
        });
  }

  void _buildScreens() {
    _screens = [
      AllSongsScreen(onTap: () {}),
      SearchScreen(onTap: () {}),
      Container(color: MyColors.secondaryColor),
      ArtistsScreen(key: _artistsScreenKey, onTap: () => setState(() {})),
      const FavouriteScreen(),
    ];
  }
}
