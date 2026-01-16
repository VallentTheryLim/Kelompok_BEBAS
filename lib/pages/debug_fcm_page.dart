import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DebugFCMPage extends StatefulWidget {
  const DebugFCMPage({super.key});

  @override
  State<DebugFCMPage> createState() => _DebugFCMPageState();
}

class _DebugFCMPageState extends State<DebugFCMPage> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() => _token = token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Token')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(_token ?? 'Loading...'),
      ),
    );
  }
}
