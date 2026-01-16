import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.notification?.title ?? 'Notifikasi')),
      );
    });
  }
}
