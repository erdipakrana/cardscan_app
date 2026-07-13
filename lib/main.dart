import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardscan_app/features/cards/presentation/pages/saved_cards_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// MyApp is a StatelessWidget that defines the structure of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visiting Card Scanner', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Defining the primary theme color
      ),
      home: const SavedCardsPage(), // Setting SavedCardsPage as the home screen of the app
    );
  }
}
