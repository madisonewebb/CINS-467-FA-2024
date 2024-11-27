import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

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
      ),
      home: AuthCheck(), // Show AuthCheck with Splash Screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
      },
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
          // Show the SplashScreen while checking auth state
          return SplashScreen();
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

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Loading Animation
            Image.asset(
              'assets/logo.png', // Replace with your logo file path
              height: 120,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Loading spinner
            SizedBox(height: 20),
            Text(
              'Loading Spool Scout...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
