
class Sighting {
  final int? id;
  final String species;
  final String location;
  final DateTime date;

  Sighting({this.id, required this.species, required this.location, required this.date});

  Map<String, dynamic> toMap() => {
    'id': id,
    'species': species,
    'location': location,
    'date': date.toIso8601String(),
  };

  factory Sighting.fromMap(Map<String, dynamic> map) => Sighting(
    id: map['id'] as int?,
    species: map['species'] as String,
    location: map['location'] as String,
    date: DateTime.parse(map['date'] as String),
  );
}
