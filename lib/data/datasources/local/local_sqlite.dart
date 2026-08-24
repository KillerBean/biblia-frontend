import 'dart:io';
import 'package:biblia/core/utils/app_logger.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseRetriever {
  static const String arcDbSha256 =
      'e8efc828da248d896edd2b1d624aa620f370d6948766026bb4b25fcfcdc5c0c2';
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
      appLogger.d('Creating new copy from asset');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "db", "ARC.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      final checksum = sha256.convert(bytes).toString();
      if (checksum != arcDbSha256) {
        throw StateError('ARC.db asset integrity check failed');
      }

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      appLogger.d('Opening existing database');
    }
    return await openDatabase(path, version: 1);
  }
}
