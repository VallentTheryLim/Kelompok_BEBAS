import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OceanAlertService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static final _storage = FirebaseStorage.instance;

  static CollectionReference get _col => _db.collection('ocean_alerts');

  static Stream<QuerySnapshot> streamAlerts() {
    return _col.orderBy('date', descending: true).snapshots();
  }

  static Future<String> _uploadPhoto(File file) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User belum login');

    final ts = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage
        .ref()
        .child('ocean_alerts/${user.uid}/$ts.jpg');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  static Future<void> addAlert({
    required String type,
    required String location,
    required String description,
    required int severity,
    File? photoFile,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User belum login');

    String? photoUrl;
    if (photoFile != null) {
      photoUrl = await _uploadPhoto(photoFile);
    }

    await _col.add({
      'type': type,
      'location': location,
      'description': description,
      'severity': severity,
      'date': FieldValue.serverTimestamp(),
      'userId': user.uid,
      'photoUrl': photoUrl,
    });
  }

  static Future<void> deleteAlert(String id) async {
    await _col.doc(id).delete();
  }
}
