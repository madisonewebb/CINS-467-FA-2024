import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFilament({
    required String name,
    required String type,
    required double printTempLow,
    required double printTempHigh,
    required double price,
  }) async {
    await _db.collection('filaments').add({
      'name': name,
      'type': type,
      'printTempLow': printTempLow,
      'printTempHigh': printTempHigh,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getFilaments() {
    return _db.collection('filaments').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  Future<void> deleteFilament(String id) async {
    await _db.collection('filaments').doc(id).delete();
  }
}
