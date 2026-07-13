import 'package:drift/drift.dart';
import 'connection/connection.dart'
    if (dart.library.js_interop) 'connection/web.dart'
    if (dart.library.ffi) 'connection/native.dart';

part 'app_database.g.dart';

@DataClassName('CardData')
class Cards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get jobTitle => text().nullable()();
  TextColumn get company => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get details => text()();
}

@DriftDatabase(tables: [Cards])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
