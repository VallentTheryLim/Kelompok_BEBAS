import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/sighting.dart';

class FirebaseSightingService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> _userCol() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }
    return _db
        .collection('user_sightings')
        .doc(user.uid)
        .collection('items');
  }

  static Future<void> uploadSighting(Sighting s) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final col = _userCol();

    final docId =
        (s.id != null ? s.id.toString() : DateTime.now().millisecondsSinceEpoch.toString());

    await col.doc(docId).set({
      'localId': s.id,
      'species': s.species,
      'location': s.location,
      'date': s.date.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> deleteSighting(int id) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final col = _userCol();
    await col.doc(id.toString()).delete();
  }
}
