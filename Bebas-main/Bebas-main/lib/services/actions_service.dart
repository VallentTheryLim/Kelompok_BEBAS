import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ActionTip {
  final String title;
  final String impact;
  final String steps;

  ActionTip({
    required this.title,
    required this.impact,
    required this.steps,
  });

  factory ActionTip.fromJson(Map<String, dynamic> json) {
    return ActionTip(
      title: json['title'] ?? '',
      impact: json['impact'] ?? '',
      steps: json['steps'] ?? '',
    );
  }
}

class ActionsService {
  static Future<List<ActionTip>> loadActions() async {
    final raw = await rootBundle.loadString('assets/data/actions.json');
    final data = jsonDecode(raw) as List;
    return data.map((e) => ActionTip.fromJson(e)).toList();
  }
}
