import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'package:music_player_app/service/models/artist.dart';

class ArtistInfoScreen extends StatelessWidget {
  const ArtistInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = Get.arguments ?? {};
    Artist artist = arguments['artist'];
    return Scaffold(
      backgroundColor: const Color(0xFF222932),
      body: Stack(
        children: [
          _buildHeroImage(context, artist),
          _buildBlurredImageBackground(context, artist),
          _buildArtistInfo(context, artist),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, Artist artist) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Hero(
        tag: artist.id,
        child: Container(decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(artist.imageUrl), fit: BoxFit.cover))),
      ),
    );
  }

  Widget _buildBlurredImageBackground(BuildContext context, Artist artist) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Transform.flip(
        flipY: true,
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(artist.imageUrl), fit: BoxFit.cover)),
          child: ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 0.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.9),
                      Colors.black
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArtistInfo(BuildContext context, Artist artist) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                artist.name,
                style: GoogleFonts.teko(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Followers : ${artist.followers}",
                style: GoogleFonts.teko(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            _buildArtistGenres(context, artist),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistGenres(BuildContext context, Artist artist) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Text(
            "Genres :  ",
            style: GoogleFonts.teko(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: artist.genres
                    .map((genre) => Text(
                          artist.genres.indexOf(genre) == artist.genres.length - 1 ? genre : '$genre ,',
                          style: GoogleFonts.teko(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
