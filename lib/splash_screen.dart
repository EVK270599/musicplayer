import 'package:flutter/material.dart';
import 'package:flutter_svg_animations_with_rive_tutorial/music_player_page.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loadingError = false;

  @override
  void initState() {
    super.initState();
    _loadAnimationAndNavigate();
  }

  Future<void> _loadAnimationAndNavigate() async {
    try {
      // Simulate loading time
      await Future.delayed(Duration(seconds: 3));
      // Check if the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MusicPlayerPage(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _loadingError = true;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[600],
      body: Center(
        child: _loadingError
            ? Text(
                'Error loading animation',
                style: TextStyle(color: Colors.red),
              )
            : Container(
                width: 400,
                child: RiveAnimation.asset(
                  'assets/radioSplashAnimation.riv',
                ),
              ),
      ),
    );
  }
}
