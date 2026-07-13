import 'package:drift/drift.dart';
import 'package:cardscan_app/core/database/app_database.dart';

abstract class CardsLocalDatasource {
  Stream<List<CardData>> watchAllCards();
  Future<void> insertCard({
    required String name,
    String? jobTitle,
    String? company,
    String? email,
    String? phone,
    String? website,
    required String details,
  });
  Future<void> deleteCard(int id);
}

class CardsLocalDatasourceImpl implements CardsLocalDatasource {
  final AppDatabase _db;

  CardsLocalDatasourceImpl(this._db);

  @override
  Stream<List<CardData>> watchAllCards() {
    return _db.select(_db.cards).watch();
  }

  @override
  Future<void> insertCard({
    required String name,
    String? jobTitle,
    String? company,
    String? email,
    String? phone,
    String? website,
    required String details,
  }) async {
    await _db.into(_db.cards).insert(
          CardsCompanion.insert(
            name: name,
            jobTitle: Value(jobTitle),
            company: Value(company),
            email: Value(email),
            phone: Value(phone),
            website: Value(website),
            details: details,
          ),
        );
  }

  @override
  Future<void> deleteCard(int id) async {
    await (_db.delete(_db.cards)..where((tbl) => tbl.id.equals(id))).go();
  }
}
