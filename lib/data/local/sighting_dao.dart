
import '../../models/sighting.dart';
import 'app_db.dart';

class SightingDao {
  final _table = 'sightings';

  Future<List<Sighting>> getAll() async {
    final db = await AppDb.instance.database;
    final rows = await db.query(_table, orderBy: 'date DESC');
    return rows.map((e) => Sighting.fromMap(e)).toList();
  }

  Future<int> insert(Sighting s) async {
    final db = await AppDb.instance.database;
    return db.insert(_table, s.toMap());
  }

  Future<int> update(Sighting s) async {
    final db = await AppDb.instance.database;
    return db.update(_table, s.toMap(), where: 'id = ?', whereArgs: [s.id]);
  }

  Future<int> delete(int id) async {
    final db = await AppDb.instance.database;
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
