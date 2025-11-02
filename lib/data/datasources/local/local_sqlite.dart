import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseRetriever {
  static final DatabaseRetriever _instance = DatabaseRetriever._();
  static DatabaseRetriever get instance => _instance;

  Future<Database>? _db;
  String? dbPath;

  DatabaseRetriever._();

  Future<Database> get db async {
    _db ??= loadDatabase();
    return await _db!;
  }

  Future<Database> loadDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
    }

    if (!Platform.isAndroid && !Platform.isIOS) {
      databaseFactory = databaseFactoryFfi;
    }

    String path = dbPath ?? join(await getDatabasesPath(), "ARC.db");

    var exists = await databaseExists(path);

    if (!exists) {
      if (kDebugMode) {
        print("Creating new copy from asset");
      }
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "db", "ARC.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      if (kDebugMode) {
        print("Opening existing database");
      }
    }
    return await openDatabase(path, version: 1);
  }
}