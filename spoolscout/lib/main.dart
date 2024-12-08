import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(SpoolScoutApp());
}

class SpoolScoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spool Scout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ChickenWonder', // Apply your custom font globally
      ),
      home: SplashScreen(), // Start with the SplashScreen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAuthCheck();
  }

  void _navigateToAuthCheck() async {
    await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthCheck()), // Navigate to AuthCheck
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/wallpaper.png', // Ensure wallpaper exists
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png', // Your logo path
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  color: const Color.fromRGBO(4, 107, 123, 1), // Custom spinner color
                ),
                SizedBox(height: 20),
                Text(
                  'Loading Spool Scout...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ChickenWonder',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a temporary loading screen
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // User is authenticated; navigate to HomeScreen
          return HomeScreen();
        } else {
          // User is not authenticated; show LoginScreen
          return LoginScreen();
        }
      },
    );
  }
}
