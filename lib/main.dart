import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart'; // Import the flare_flutter package
import 'package:flutter_svg_animations_with_rive_tutorial/splash_screen.dart';

void main() => runApp(AppWidget());

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SVG Animations With Rive',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: CustomSplashScreen(),
    );
  }
}

class CustomSplashScreen extends StatefulWidget {
  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Animation Widget
          Positioned.fill(
            child: FlareActor(
                "assets/star_rating.flr", // Replace with your Flare animation file path
                animation:
                    "Start Rating", // Replace with your Flare animation name
                fit: BoxFit.contain,
                alignment: Alignment.topCenter),
          ),
          // Content
          Center(
            child: _isLoading ? CircularProgressIndicator() : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to My Album !',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SplashScreen(),
                ),
              );
            },
            child: Text('Get Started'),
          ),
        ],
      ),
    );
  }
}
