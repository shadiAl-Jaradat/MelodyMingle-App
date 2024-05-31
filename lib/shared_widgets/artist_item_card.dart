import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/models/artist.dart';
import 'package:get/get.dart';
import 'package:music_player_app/screens/artist_info%20_screen.dart';
import 'package:music_player_app/utils/constants.dart';

class ArtistItemCard extends StatefulWidget {
  const ArtistItemCard({super.key,required this.artist});

  final Artist artist;
  @override
  State<ArtistItemCard> createState() => _ArtistItemCardState();
}

class _ArtistItemCardState extends State<ArtistItemCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const ArtistInfoScreen(), arguments: {'artist': widget.artist});
      },
      child: Hero(
        tag: widget.artist.id,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.artist.imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          height: 250,
          width: 100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.artist.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
