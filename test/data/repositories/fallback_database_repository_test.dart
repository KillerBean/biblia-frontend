import 'package:biblia/core/utils/config_service.dart';
import 'package:biblia/data/datasources/local/local_sqlite.dart';
import 'package:biblia/data/datasources/remote/biblia_remote_data_source.dart';
import 'package:biblia/data/repositories/fallback_database_repository.dart';
import 'package:biblia/domain/entities/book.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

import 'fallback_database_repository_test.mocks.dart';

@GenerateMocks([BibliaRemoteDataSource, ConfigService])
void main() {
  late FallbackDatabaseRepository repository;
  late Directory tempDir;
  late String dbPath;
  late MockBibliaRemoteDataSource mockRemoteDataSource;
  late MockConfigService mockConfigService;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    tempDir = await Directory.systemTemp.createTemp('test_db');
    dbPath = '${tempDir.path}/test.db';

    final ByteData data = await rootBundle.load('assets/db/ARC.db');
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    // Override the path to the database
    DatabaseRetriever.instance.dbPath = dbPath;

    mockRemoteDataSource = MockBibliaRemoteDataSource();
    mockConfigService = MockConfigService();

    // Ensure we use the local DB by default
    when(mockConfigService.isApiEnabled()).thenAnswer((_) async => false);

    repository = FallbackDatabaseRepository(mockRemoteDataSource, mockConfigService);
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('FallbackDatabaseRepository', () {
    test('getBooks should return a list of books', () async {
      // Act
      final books = await repository.getBooks();

      // Assert
      expect(books, isA<List<Book>>());
      expect(books.length, 66);
    });
  });
}