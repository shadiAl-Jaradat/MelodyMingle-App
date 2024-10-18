import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/domain/controllers.dart';
import 'package:music_player_app/presentation/screens/all_songs_screen.dart';
import 'package:music_player_app/presentation/screens/artists_screen.dart';
import 'package:music_player_app/presentation/screens/favourite_screen.dart';
import 'package:music_player_app/presentation/screens/splash_screen.dart';
import 'package:music_player_app/presentation/shared_widgets/custom_navigation_bar.dart';
import 'package:music_player_app/service/models/artist.dart';
import 'package:music_player_app/service/models/song.dart';
import 'package:music_player_app/service/spotify_service.dart';
import 'package:get/get.dart';
import 'package:music_player_app/utils/colors.dart';
import 'package:music_player_app/utils/constants.dart';

import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AudioPlayerController audioPlayerController = Get.put(AudioPlayerController(currentIndex: 0.obs, song: Rx<Song?>(null)));
  final SpotifyService spotifyService = SpotifyService(Dio());
  final RxBool loading = true.obs;
  final RxInt tabIndex = 0.obs;
  final Rx<Key> artistsScreenKey = UniqueKey().obs;
  final List<Widget> _screens = [];

  @override
  Widget build(BuildContext context) {
    if (_screens.isEmpty) {
      _buildScreens();
      getSongsAndPodcasts();
    }
    return Obx(() {
      if (loading.value) {
        return const SplashScreen();
      }
      return Scaffold(
        body: Stack(
          children: [
            _buildBackgroundContainer(),
            _buildNowPlayingBar(context),
          ],
        ),
        bottomNavigationBar: CustomTabBar(
          onTabChange: (index) {
            if (index == 3) {
              // Force rebuild of the ArtistsScreen when it's selected
              artistsScreenKey.value = UniqueKey();
              _buildScreens();
            }
            tabIndex.value = index;
          },
        ),
      );
    });
  }

  Future<void> getSongsAndPodcasts() async {
    try {
      if (audioPlayerController.listOfSongs.isEmpty) {
        List<Song> listSongs = await spotifyService.getRecommendations(genres: genres);
        audioPlayerController.setListOfSongs(listSongs);
      }
      if (audioPlayerController.listOfArtist.isEmpty) {
        List<Artist> listArtist = await spotifyService.getAllArtists(artists);
        audioPlayerController.setListOfArtist(listArtist);
      }
      await Future.delayed(const Duration(seconds: 1));
      loading.value = false;
    } catch (e) {
      loading.value = false; // Ensure loading ends even on error
    }
  }

  Widget _buildBackgroundContainer() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color(0xFF222932),
      child: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: tabIndex.value,
            children: _screens,
          ),
        ),
      ),
    );
  }

  Widget _buildNowPlayingBar(BuildContext context) {
    return Obx(() => audioPlayerController.song.value != null
        ? Positioned(
            bottom: 4,
            right: 5,
            left: 5,
            child: GestureDetector(
              onTap: () => Get.toNamed('/now_playing'),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(color: MyColors.tertiaryColor.withOpacity(0.12)),
                    child: ListTile(leading: _buildSongThumbnail(), trailing: _buildPlaybackControls(), title: _buildSongTitle()),
                  ),
                ),
              ),
            ),
          )
        : SizedBox(
            child: Text('${audioPlayerController.currentIndex.string} ${audioPlayerController.song.value?.artist ?? ''}'),
          ));
  }

  Widget _buildSongThumbnail() {
    return Transform.translate(
      offset: const Offset(-4.0, 3.0),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(image: NetworkImage(audioPlayerController.song.value?.imageUrl ?? ''), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Transform.translate(
      offset: const Offset(18.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPlayPauseButton(),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return InkWell(
      onTap: () async {
        if (audioPlayerController.isPlaying.value) {
          await audioPlayerController.pause();
        } else {
          await audioPlayerController.play();
        }
      },
      child: Obx(
        () => Icon(
          audioPlayerController.isPlaying.value ? Icons.pause : Icons.play_arrow,
          color: MyColors.tertiaryColor,
          size: 38,
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return InkWell(
      onTap: () async {
        if (audioPlayerController.inSearchMode.value) {
          if (audioPlayerController.currentIndex.value != audioPlayerController.searchedSongs.length - 1) {
            _playNextSong(audioPlayerController.searchedSongs);
          }
        } else {
          if (audioPlayerController.currentIndex.value != audioPlayerController.listOfSongs.length - 1) {
            _playNextSong(audioPlayerController.listOfSongs);
          }
        }
      },
      child: Obx(
        () => Icon(
          Icons.skip_next,
          color: audioPlayerController.inSearchMode.value
              ? (audioPlayerController.currentIndex.value != audioPlayerController.searchedSongs.length - 1
                  ? MyColors.tertiaryColor
                  : MyColors.tertiaryColor.withOpacity(0.4))
              : (audioPlayerController.currentIndex.value != audioPlayerController.listOfSongs.length - 1
                  ? MyColors.tertiaryColor
                  : MyColors.tertiaryColor.withOpacity(0.4)),
          size: 38,
        ),
      ),
    );
  }

  void _playNextSong(List<Song> songsList) async {
    audioPlayerController.setCurrentIndex(audioPlayerController.currentIndex.value + 1);
    Song newSong = songsList[audioPlayerController.currentIndex.value];
    audioPlayerController.setSong(newSong);
    await audioPlayerController.play();
  }

  Widget _buildSongTitle() {
    return Text(
      audioPlayerController.song.value?.name ?? '',
      style: GoogleFonts.poppins(
        color: MyColors.tertiaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  void _buildScreens() {
    _screens.clear();
    _screens.addAll([
      AllSongsScreen(),
      const SearchScreen(),
      const SizedBox.shrink(),
      ArtistsScreen(key: artistsScreenKey.value, onTap: () {}),
      const FavouriteScreen(),
    ]);
  }
}
