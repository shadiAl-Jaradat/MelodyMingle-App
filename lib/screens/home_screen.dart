import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  Obx(() => audioPlayerController.song.value != null
                      ? Positioned(
                          bottom: 4,
                          right: 5,
                          left: 5,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed('/now_playing')?.then((value) => setState(() {}));
                            },
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: MyColors.tertiaryColor.withOpacity(0.12),
                                  ),
                                  child: ListTile(
                                    leading: Transform.translate(
                                      offset: const Offset(-4.0, 3.0),
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(audioPlayerController.song.value?.imageUrl ?? ''),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    trailing: Transform.translate(
                                      offset: const Offset(18.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              if (audioPlayerController.isPlaying.value) {
                                                await audioPlayerController.pause();
                                              } else {
                                                await audioPlayerController.play();
                                              }
                                              setState(() {});
                                            },
                                            child: Obx(
                                              () => Icon(
                                                audioPlayerController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                                color: MyColors.tertiaryColor,
                                                size: 38,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (audioPlayerController.inSearchMode.value) {
                                                if (audioPlayerController.currentIndex.value !=
                                                    audioPlayerController.searchedSongs.length - 1) {
                                                  audioPlayerController.setCurrentIndex(audioPlayerController.currentIndex.value + 1);

                                                  Song newSong =
                                                      audioPlayerController.searchedSongs[audioPlayerController.currentIndex.value];
                                                  audioPlayerController.setSong(newSong);
                                                  await audioPlayerController.play();
                                                  setState(() {});
                                                }
                                              } else {
                                                if (audioPlayerController.currentIndex.value !=
                                                    audioPlayerController.listOfSongs.length - 1) {
                                                  audioPlayerController.setCurrentIndex(audioPlayerController.currentIndex.value + 1);
                                                  Song newSong =
                                                      audioPlayerController.listOfSongs[audioPlayerController.currentIndex.value];
                                                  audioPlayerController.setSong(newSong);
                                                  await audioPlayerController.play();
                                                  setState(() {});
                                                }
                                              }
                                            },
                                            child: Obx(
                                              () => audioPlayerController.inSearchMode.value
                                                  ? Icon(
                                                      Icons.skip_next,
                                                      color: audioPlayerController.currentIndex.value !=
                                                              audioPlayerController.searchedSongs.length - 1
                                                          ? MyColors.tertiaryColor
                                                          : MyColors.tertiaryColor.withOpacity(0.4),
                                                      size: 38,
                                                    )
                                                  : Icon(
                                                      Icons.skip_next,
                                                      color: audioPlayerController.currentIndex.value !=
                                                              audioPlayerController.listOfSongs.length - 1
                                                          ? MyColors.tertiaryColor
                                                          : MyColors.tertiaryColor.withOpacity(0.4),
                                                      size: 38,
                                                    ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    title: Text(
                                      audioPlayerController.song.value?.name ?? '',
                                      style: GoogleFonts.poppins(
                                        color: MyColors.tertiaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          child: Text('${audioPlayerController.currentIndex.string} ${audioPlayerController.song.value?.artist ?? ''}'),
                        ))
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
