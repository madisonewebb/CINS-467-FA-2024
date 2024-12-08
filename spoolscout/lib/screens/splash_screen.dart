import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Wallpaper background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Centered Logo
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              // "Loading Spool Scout" Text
              Text(
                'Loading Spool Scout...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ChickenWonder', // Custom font
                  color: Color.fromRGBO(37, 150, 190, 1), // Custom color
                ),
              ),
              SizedBox(height: 20),
              // Circular Loading Indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(37, 150, 190, 1), // Custom color
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
