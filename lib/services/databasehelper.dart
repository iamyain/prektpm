import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT)',
    );
  }

  Future<int> registerUser(String name, String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);

    final userData = {
      'name': name,
      'email': email,
      'password': hashedPassword,
    };

    return await db!.insert('users', userData);
  }

  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);

    final results = await db!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
      limit: 1,
    );

    return results.isNotEmpty;
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
