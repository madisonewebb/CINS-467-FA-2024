import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Initialize GoogleSignIn

  // Sign-Up Method
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the created user
    } catch (e) {
      print('Sign-Up Error: $e');
      return null;
    }
  }

  // Sign-In Method
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the signed-in user
    } catch (e) {
      print('Sign-In Error: $e');
      return null;
    }
  }

  // Sign-Out Method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut(); // Sign out from Google as well
    } catch (e) {
      print('Sign-Out Error: $e');
    }
  }

  // Google Sign-In Method
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // If user cancels the Google Sign-In, return null
        print('Google Sign-In canceled by user');
        return null;
      }

      // Obtain Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using the Google authentication token
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Authenticate with Firebase using the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user; // Return the signed-in user
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }
}
