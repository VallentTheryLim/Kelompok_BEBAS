import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/sighting.dart';
import '../data/local/sighting_dao.dart';
import '../services/firebase_sighting_service.dart';

class SightingProvider with ChangeNotifier {
  final SightingDao _dao = SightingDao();
  final _controller = StreamController<List<Sighting>>.broadcast();
  Stream<List<Sighting>> get stream => _controller.stream;

  List<Sighting> _cache = [];
  bool _loaded = false;
  bool get loaded => _loaded;

  String? lastError;

  Future<void> load() async {
    try {
      if (kIsWeb) {
        throw Exception(
          'SQLite (sqflite) tidak didukung di Flutter Web. Jalankan di Android/iOS.',
        );
      }

      final all = await _dao.getAll();
      _cache = all;
      lastError = null;
    } catch (e) {
      lastError = e.toString();
      _cache = [];
    } finally {
      _loaded = true;
      _controller.add(List.unmodifiable(_cache));
      notifyListeners();
    }
  }

  Future<void> add(Sighting s) async {
    try {
      final id = await _dao.insert(s);

      final saved = Sighting(
        id: id,
        species: s.species,
        location: s.location,
        date: s.date,
      );

      _cache = [..._cache, saved];
      _controller.add(List.unmodifiable(_cache));
      notifyListeners();

      await FirebaseSightingService.uploadSighting(saved);
    } catch (e) {
      lastError = e.toString();
      notifyListeners();
    }
  }

  Future<void> remove(int id) async {
    try {
      await _dao.delete(id);

      _cache = _cache.where((e) => e.id != id).toList();
      _controller.add(List.unmodifiable(_cache));
      notifyListeners();

      await FirebaseSightingService.deleteSighting(id);
    } catch (e) {
      lastError = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
