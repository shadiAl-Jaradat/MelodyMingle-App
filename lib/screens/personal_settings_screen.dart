import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Favourite Screen\nComing Soon",
        style: GoogleFonts.poppins(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
