import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUserData(String name, int age) async {
    try {
      print('Attempting to save: $name, $age');
      await _userCollection.add({'name': name, 'age': age});
      print('Data saved successfully: $name, $age');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _userCollection.snapshots();
  }
}
