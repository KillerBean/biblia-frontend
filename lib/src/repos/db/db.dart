import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRetriever {
  late Future<Database> _db;
  Future<Database> get db async => await _db;
  DatabaseRetriever._() {
    _db = loadDatabase();
  }

  static DatabaseRetriever instance = DatabaseRetriever._();

  Future<Database> loadDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "ARC.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(url.join("assets", "db", "ARC.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    // open the database
    return await openDatabase(path, version: 1);
  }
}
