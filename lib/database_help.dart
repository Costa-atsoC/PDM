import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> db() async {
    // Get the directory for the database file
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = '${directory.path}/ridewithmeDemo2.db';

    return sql.openDatabase(
      dbPath, // Use the obtained path
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      username TEXT,
      email TEXT,
      pwd TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TIMESTAMP
    )
  ''');

    await database.execute('''
    CREATE TABLE carpool (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      date TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      userId INTEGER,
      FOREIGN KEY (userId) REFERENCES users(id)
    )
  ''');
  }

// id: the id of a item
// title, description: name and description of  activity
// created_at: the time that the item was created. It will be automatically handled by SQLite
  // Create new item
  static Future<int> createItem(
    int userId,
    String title,
    String description,
    String date,
  ) async {
    final db = await DatabaseHelper.db();

    final data = {
      'userId': userId, // Set the user's ID as the foreign key
      'title': title,
      'description': description,
      'date': date,
    };

    final id = await db.insert('carpool', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('carpool', orderBy: "id");
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('carpool', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? description, String date) async {
    final db = await DatabaseHelper.db();

    final data = {
      'title': title,
      'description': description,
      'date': date, // posteriormente sera um date time picker
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('carpool', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("carpool", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
