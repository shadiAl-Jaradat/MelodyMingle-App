import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/presentation/screens/artist_info_screen.dart';
import 'package:music_player_app/service/models/artist.dart';
import 'package:get/get.dart';

class ArtistItemCard extends StatefulWidget {
  const ArtistItemCard({super.key, required this.artist});

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
            )),
      ),
    );
  }
}

// sealed class Shape {}

// class Square implements Shape {
//   final double length;
//   Square(this.length);
// }

// class Circle implements Shape {
//   final double radius;
//   Circle(this.radius);
// }

// class SS implements Shape {
//   final double radius;
//   SS(this.radius);
// }

// double calculateArea(Shape shape, int number) {
//   String? text = number % 2 == 0 ? "shady" : null;
//   if (text is String) {
//     print(text.length);
//   }

//   return switch (shape) {
//     Square(length: var l) => l * l,
//     Circle(radius: var r) => pi * r * r,
//     _ => throw UnimplementedError(),
//   };
// }
