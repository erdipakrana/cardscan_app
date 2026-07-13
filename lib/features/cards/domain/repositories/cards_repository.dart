import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';

abstract class CardsRepository {
  Stream<List<VisitingCard>> watchAllCards();
  Future<void> saveCard({
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
