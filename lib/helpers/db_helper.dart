import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user_places('
          'id TEXT PRIMARY KEY, '
          'title TEXT, '
          'image TEXT, '
          'loc_lat REAL, '
          'loc_lng REAL, '
          'address TEXT'
          ')',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object?> data) async {
    try {
      final db = await DBHelper.database();
      await db.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Data inserted successfully into $table');
    } catch (error) {
      print('Error inserting data into $table: $error');
      throw error;
    }
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    try {
      final db = await DBHelper.database();
      final result = await db.query(table);
      print('Retrieved ${result.length} records from $table');
      return result;
    } catch (error) {
      print('Error retrieving data from $table: $error');
      return [];
    }
  }

  // Additional helper method to delete a specific place
  static Future<void> deletePlace(String id) async {
    try {
      final db = await DBHelper.database();
      await db.delete('user_places', where: 'id = ?', whereArgs: [id]);
      print('Place with id $id deleted successfully');
    } catch (error) {
      print('Error deleting place with id $id: $error');
      throw error;
    }
  }

  // Helper method to clear all places (useful for testing)
  static Future<void> clearAllPlaces() async {
    try {
      final db = await DBHelper.database();
      await db.delete('user_places');
      print('All places cleared from database');
    } catch (error) {
      print('Error clearing places: $error');
      throw error;
    }
  }

  // Helper method to get database info
  static Future<void> printDatabaseInfo() async {
    try {
      final db = await DBHelper.database();
      final count = await db.rawQuery(
        'SELECT COUNT(*) as count FROM user_places',
      );
      print('Total places in database: ${count.first['count']}');

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );
      print(
        'Tables in database: ${tables.map((table) => table['name']).toList()}',
      );
    } catch (error) {
      print('Error getting database info: $error');
    }
  }
}
