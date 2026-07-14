import 'package:csv/csv.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';

class ExportHelper {
  /// Converts a single visiting card to a standard vCard 3.0 text representation.
  static String convertToVCard(VisitingCard card) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:${card.name}');
    if (card.company != null && card.company!.isNotEmpty) {
      buffer.writeln('ORG:${card.company}');
    }
    if (card.jobTitle != null && card.jobTitle!.isNotEmpty) {
      buffer.writeln('TITLE:${card.jobTitle}');
    }
    if (card.email != null && card.email!.isNotEmpty) {
      buffer.writeln('EMAIL;TYPE=PREF,INTERNET:${card.email}');
    }
    if (card.phone != null && card.phone!.isNotEmpty) {
      buffer.writeln('TEL;TYPE=CELL,VOICE:${card.phone}');
    }
    if (card.website != null && card.website!.isNotEmpty) {
      buffer.writeln('URL:${card.website}');
    }
    buffer.writeln('END:VCARD');
    return buffer.toString();
  }

  /// Converts a list of visiting cards to CSV format.
  static String convertToCsv(List<VisitingCard> cards) {
    final List<List<dynamic>> rows = [
      ['Name', 'Job Title', 'Company', 'Email', 'Phone', 'Website', 'Raw Details', 'Created At']
    ];
    for (final card in cards) {
      rows.add([
        card.name,
        card.jobTitle ?? '',
        card.company ?? '',
        card.email ?? '',
        card.phone ?? '',
        card.website ?? '',
        card.details.replaceAll('\n', '; '),
        card.createdAt?.toIso8601String() ?? '',
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  /// Shares a single card's contact details as a vCard.
  static Future<void> shareAsVCard(VisitingCard card) async {
    final vcard = convertToVCard(card);
    await Share.share(
      vcard,
      subject: 'Contact card: ${card.name}',
      sharePositionOrigin: null, // can be customized for iPad
    );
  }

  /// Shares a list of cards as a CSV dump.
  static Future<void> shareAsCsv(List<VisitingCard> cards) async {
    final csv = convertToCsv(cards);
    await Share.share(
      csv,
      subject: 'Exported Contacts CSV',
    );
  }

  /// Saves a visiting card to the device address book.
  static Future<bool> saveToDeviceContacts(VisitingCard card) async {
    try {
      if (await FlutterContacts.requestPermission(readonly: false)) {
        final contact = Contact()
          ..name.first = card.name
          ..phones = card.phone != null && card.phone!.isNotEmpty
              ? [Phone(card.phone!)]
              : []
          ..emails = card.email != null && card.email!.isNotEmpty
              ? [Email(card.email!)]
              : []
          ..organizations = (card.company != null && card.company!.isNotEmpty) ||
                  (card.jobTitle != null && card.jobTitle!.isNotEmpty)
              ? [
                  Organization(
                    company: card.company ?? '',
                    title: card.jobTitle ?? '',
                  )
                ]
              : []
          ..websites = card.website != null && card.website!.isNotEmpty
              ? [Website(card.website!, label: WebsiteLabel.homepage)]
              : [];
        
        await contact.insert();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
