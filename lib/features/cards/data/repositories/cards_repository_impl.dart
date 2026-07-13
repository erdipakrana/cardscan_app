import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';
import 'package:cardscan_app/features/cards/domain/repositories/cards_repository.dart';
import 'package:cardscan_app/features/cards/data/datasources/cards_local_datasource.dart';
import 'package:cardscan_app/features/cards/data/models/card_model.dart';

class CardsRepositoryImpl implements CardsRepository {
  final CardsLocalDatasource _datasource;

  CardsRepositoryImpl(this._datasource);

  @override
  Stream<List<VisitingCard>> watchAllCards() {
    return _datasource.watchAllCards().map((list) =>
        list.map((cardData) => CardModel.toEntity(cardData)).toList());
  }

  @override
  Future<void> saveCard({
    required String name,
    String? jobTitle,
    String? company,
    String? email,
    String? phone,
    String? website,
    required String details,
  }) async {
    await _datasource.insertCard(
      name: name,
      jobTitle: jobTitle,
      company: company,
      email: email,
      phone: phone,
      website: website,
      details: details,
    );
  }

  @override
  Future<void> deleteCard(int id) async {
    await _datasource.deleteCard(id);
  }
}
