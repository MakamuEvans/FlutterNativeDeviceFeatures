import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static Future<sql.Database> conn() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
          return db.execute(
              "create table great_places(id text primary key, title text,image text, loc_lat REAL, loc_lng REAL, address TEXT)");
        }, version: 1);
  }
  static Future<void> insert(String table, Map<String, Object> data) async {
    final conn = await DbHelper.conn();
    conn.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async{
    final conn = await DbHelper.conn();
    return conn.query(table);
  }
}
