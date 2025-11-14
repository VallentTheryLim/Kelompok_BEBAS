import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Threat {
  final String type;
  final String severity;
  final String description;

  Threat({
    required this.type,
    required this.severity,
    required this.description,
  });

  factory Threat.fromJson(Map<String, dynamic> json) {
    return Threat(
      type: json['type'] ?? '',
      severity: json['severity'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ThreatsService {
  static Future<List<Threat>> loadThreats() async {
    final raw = await rootBundle.loadString('assets/data/threats.json');
    final data = jsonDecode(raw) as List;
    return data.map((e) => Threat.fromJson(e)).toList();
  }
}
