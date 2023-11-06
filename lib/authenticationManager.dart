import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:sqflite/sqflite.dart' as sql;
import 'database_help.dart';

class Authentication {
  // Create a new user
  static Future<int> createUser(
      String username, String email, String password) async {
    final db = await DatabaseHelper.db();
    final data = {
      'username': username,
      'email': email,
      'pwd': password,
    };

    final id = await db.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

// Read all users
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DatabaseHelper.db();
    final users = await db.query('users', orderBy: "id");
    return users ?? <Map<String, dynamic>>[];
  }

// Get a single user by id
  static Future<List<Map<String, dynamic>>> getUser(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('users', where: "id = ?", whereArgs: [id], limit: 1);
  }

// Update a user by id
  static Future<int> updateUser(
      int id, String username, String email, String password) async {
    final db = await DatabaseHelper.db();

    final data = {
      'username': username,
      'email': email,
      'pwd': password,
      'updatedAt': DateTime.now().toString()
    };

    final result =
        await db.update('users', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

// Delete a user by id
  static Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("users", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting a user: $err");
    }
  }

  static Future<int> login(String username, String password) async {
    // Assuming _formKey.currentState!.validate() is true

    // Retrieve the list of users
    final users = await Authentication.getUsers();

    // Check if the provided email and password match any user's credentials
    final authenticatedUser = users.firstWhere(
      (user) => user['username'] == username && user['pwd'] == password,
    );

    if (authenticatedUser != []) {
      // Authentication successful
      return 1;
      // Perform actions after successful login, e.g., route to a new screen
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Authentication failed
      return 2;
      // You might want to show an error message to the user on the login screen
    }
  }

  static Future<int> register(
      String email, String username, String password) async {
    // Assuming _formKey.currentState!.validate() is true

    // Retrieve the list of users
    final users = await Authentication.getUsers();

    // Check if the provided email and password match any user's credentials
    final authenticatedUser = users.firstWhere(
      (user) => user['username'] == username && user['pwd'] == password,
    );

    if (authenticatedUser != []) {
      // Authentication successful
      return 1;
      // Perform actions after successful login, e.g., route to a new screen
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Authentication failed
      return 2;
      // You might want to show an error message to the user on the login screen
    }
  }
}
