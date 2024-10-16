import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Save data to Firebase
  Future<void> saveUserData(String name, int age) async {
    try {
      await usersCollection.add({
        'name': name,
        'age': age,
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Stream for retrieving user data in real-time
  Stream<QuerySnapshot> getUsersStream() {
    return usersCollection.snapshots();
  }
}
