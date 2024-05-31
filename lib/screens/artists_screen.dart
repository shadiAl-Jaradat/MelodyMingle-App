import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/core/controllers.dart';
import 'package:music_player_app/shared_widgets/artist_item_card.dart';
import 'package:music_player_app/utils/colors.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key, required this.onTap});

  final Function() onTap;

  @override
  _ArtistsScreenState createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> with TickerProviderStateMixin {
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
          (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    _offsetAnimations = List.generate(
      itemCount,
          (index) => Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationControllers[index],
          curve: Curves.easeInOut,
        ),
      ),
    );

    for (int i = 0; i < itemCount; i++) {
      // Adding a delay to each animation's start time
      Future.delayed(Duration(milliseconds: 100 * i), () {
        _animationControllers[i].forward();
      });
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
    return Obx(() => Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Artists',
            style: GoogleFonts.poppins(
              color: MyColors.tertiaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: audioPlayerController.listOfArtist.length,
              itemBuilder: (context, index) {
                return SlideTransition(
                  position: _offsetAnimations[index],
                  child: ArtistItemCard(
                    artist: audioPlayerController.listOfArtist[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}


// this solution after adding loadMoreArtists() method to the AudioPlayerController class


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:music_player_app/core/controllers.dart';
// import 'package:music_player_app/shared_widgets/artist_item_card.dart';
//
// class ArtistsScreen extends StatefulWidget {
//   const ArtistsScreen({super.key, required this.onTap});
//
//   final Function() onTap;
//
//   @override
//   _ArtistsScreenState createState() => _ArtistsScreenState();
// }
//
// class _ArtistsScreenState extends State<ArtistsScreen> with TickerProviderStateMixin {
//   final AudioPlayerController audioPlayerController = Get.find();
//
//   late List<AnimationController> _animationControllers = [];
//   late List<Animation<Offset>> _offsetAnimations = [];
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _initializeAnimations() {
//     _setupAnimations(audioPlayerController.listOfArtist.length);
//   }
//
//   void _setupAnimations(int count) {
//     for (int i = _animationControllers.length; i < count; i++) {
//       AnimationController controller = AnimationController(
//         duration: const Duration(milliseconds: 500),
//         vsync: this,
//       );
//       _animationControllers.add(controller);
//
//       var animation = Tween<Offset>(
//         begin: const Offset(0, 1),
//         end: Offset.zero,
//       ).animate(
//         CurvedAnimation(
//           parent: controller,
//           curve: Curves.easeInOut,
//         ),
//       );
//       _offsetAnimations.add(animation);
//
//       if (mounted) {
//         Future.delayed(Duration(milliseconds: 100 * (i - _animationControllers.length)), () {
//           controller.forward();
//         });
//       }
//     }
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
//       // Assuming you have a method to load more artists
//       audioPlayerController.loadMoreArtists().then((_) {
//         if (mounted) {
//           setState(() {
//             _setupAnimations(audioPlayerController.listOfArtist.length);
//           });
//         }
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     for (var controller in _animationControllers) {
//       controller.dispose();
//     }
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Artists',
//             style: GoogleFonts.poppins(
//               color: MyColors.tertiaryColor,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: GridView.builder(
//               controller: _scrollController,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 0.7,
//               ),
//               itemCount: audioPlayerController.listOfArtist.length,
//               itemBuilder: (context, index) {
//                 return SlideTransition(
//                   position: _offsetAnimations[index],
//                   child: ArtistItemCard(
//                     artist: audioPlayerController.listOfArtist[index],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }

