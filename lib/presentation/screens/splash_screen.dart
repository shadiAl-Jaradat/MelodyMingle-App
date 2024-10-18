import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            const BackGround(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Melody Mingle",
                    style: GoogleFonts.teko(
                      color: MyColors.tertiaryColor.withOpacity(0.9),
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    "“ Where Melodies Meet and Scales Mingle ”",
                    style: GoogleFonts.teko(
                      color: MyColors.tertiaryColor.withOpacity(0.9),
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const AnimatedColorWidget(),
          ClipRect(
            // Add this widget
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container()),
          ),
        ],
      ),
    );
  }
}

class AnimatedColorWidget extends StatefulWidget {
  const AnimatedColorWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedColorWidgetState createState() => _AnimatedColorWidgetState();
}

class _AnimatedColorWidgetState extends State<AnimatedColorWidget> {
  final List<Color> _colors = [MyColors.secondaryColor, MyColors.primaryColor];
  Color _color = MyColors.secondaryColor;
  Timer? _timer;
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      setState(() {
        _colorIndex = (_colorIndex + 1) % _colors.length;
        _color = _colors[_colorIndex];
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -20.0,
      right: 4,
      left: 4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600), // Duration of the fade
            width: MediaQuery.of(context).size.width - 30,
            height: 180,
            decoration: ShapeDecoration(
              color: _color.withOpacity(0.45),
              shape: const OvalBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
