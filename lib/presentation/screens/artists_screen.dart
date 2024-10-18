import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/domain/controllers.dart';
import 'package:music_player_app/presentation/shared_widgets/artist_item_card.dart';
import 'package:music_player_app/utils/colors.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key, required this.onTap});

  final Function() onTap;

  @override
  ArtistsScreenState createState() => ArtistsScreenState();
}

class ArtistsScreenState extends State<ArtistsScreen> with TickerProviderStateMixin {
  final AudioPlayerController audioPlayerController = Get.find();
  late List<AnimationController> _animationControllers;
  late List<Animation<Offset>> _offsetAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final int itemCount = audioPlayerController.listOfArtist.length;
    _animationControllers = List.generate(
      itemCount,
      (index) => AnimationController(duration: const Duration(milliseconds: 500), vsync: this),
    );

    _offsetAnimations = List.generate(
      itemCount,
      (index) => Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _animationControllers[index], curve: Curves.easeInOut)),
    );

    for (int i = 0; i < itemCount; i++) {
      Future.delayed(
        Duration(milliseconds: 100 * i),
        () => mounted && !_animationControllers[i].isCompleted ? _animationControllers[i].forward() : {},
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildArtistsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Artists',
      style: GoogleFonts.poppins(color: MyColors.tertiaryColor, fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildArtistsGrid() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: audioPlayerController.listOfArtist.length,
        itemBuilder: (context, index) => _buildAnimatedArtistCard(index),
      ),
    );
  }

  Widget _buildAnimatedArtistCard(int index) => Obx(
        () => SlideTransition(
          position: _offsetAnimations[index],
          child: ArtistItemCard(artist: audioPlayerController.listOfArtist[index]),
        ),
      );
}
