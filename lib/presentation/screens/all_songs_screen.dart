import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/domain/controllers.dart';
import 'package:music_player_app/presentation/shared_widgets/song_item_card.dart';
import 'package:music_player_app/utils/colors.dart';

class AllSongsScreen extends StatelessWidget {
  AllSongsScreen({super.key});

  final AudioPlayerController audioPlayerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: audioPlayerController.listOfSongs.length + 1,
        itemBuilder: (context, index) => index == 0 ? _buildHeader() : _buildSongItem(index),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Songs',
            style: GoogleFonts.poppins(color: MyColors.tertiaryColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Obx(
            () => Text(
              audioPlayerController.listOfSongs.length.toString(),
              style: TextStyle(color: MyColors.tertiaryColor.withOpacity(0.7), fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSongItem(int index) {
    final song = audioPlayerController.listOfSongs[index - 1];
    return SongItemCard(song: song, onTap: () => _onSongTap(index - 1, song));
  }

  void _onSongTap(int index, song) {
    audioPlayerController.setInSearchMode(false);
    if (audioPlayerController.song.value != null && audioPlayerController.song.value == song) {
      audioPlayerController.resume();
    } else {
      audioPlayerController.currentIndex.value = index;
      audioPlayerController.setSong(song);
      audioPlayerController.play();
    }
  }
}
