import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MarineSpecies {
  final String name;
  final String latin;
  final String status;

  MarineSpecies({
    required this.name,
    required this.latin,
    required this.status,
  });

  factory MarineSpecies.fromJson(Map<String, dynamic> json) {
    return MarineSpecies(
      name: json['name'] ?? '',
      latin: json['latin'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class SpeciesService {
  static Future<List<MarineSpecies>> loadSpecies() async {
    final raw = await rootBundle.loadString('assets/data/species.json');
    final data = jsonDecode(raw) as List;
    return data.map((e) => MarineSpecies.fromJson(e)).toList();
  }
}
