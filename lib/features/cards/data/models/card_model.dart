import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';
import 'package:cardscan_app/core/database/app_database.dart';

class CardModel {
  static VisitingCard toEntity(CardData data) {
    return VisitingCard(
      id: data.id,
      name: data.name,
      jobTitle: data.jobTitle,
      company: data.company,
      email: data.email,
      phone: data.phone,
      website: data.website,
      details: data.details,
      imagePath: data.imagePath,
      createdAt: data.createdAt,
    );
  }

  static CardData fromEntity(VisitingCard entity) {
    return CardData(
      id: entity.id,
      name: entity.name,
      jobTitle: entity.jobTitle,
      company: entity.company,
      email: entity.email,
      phone: entity.phone,
      website: entity.website,
      details: entity.details,
      imagePath: entity.imagePath,
      createdAt: entity.createdAt ?? DateTime.now(),
    );
  }
}
