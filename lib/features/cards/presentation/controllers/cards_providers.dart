import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:cardscan_app/core/database/app_database.dart';
import 'package:cardscan_app/features/cards/data/datasources/cards_local_datasource.dart';
import 'package:cardscan_app/features/cards/data/repositories/cards_repository_impl.dart';
import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';
import 'package:cardscan_app/features/cards/domain/repositories/cards_repository.dart';

// Database Provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Datasource Provider
final cardsLocalDatasourceProvider = Provider<CardsLocalDatasource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CardsLocalDatasourceImpl(db);
});

// Repository Provider
final cardsRepositoryProvider = Provider<CardsRepository>((ref) {
  final datasource = ref.watch(cardsLocalDatasourceProvider);
  return CardsRepositoryImpl(datasource);
});

// Stream of Visiting Cards Provider
final cardsStreamProvider = StreamProvider<List<VisitingCard>>((ref) {
  final repository = ref.watch(cardsRepositoryProvider);
  return repository.watchAllCards();
});

// Card Scanner State definition
class CardScannerState {
  final XFile? image;
  final String extractedText;
  final bool isScanned;
  final bool isLoading;
  final String? errorMessage;
  
  // New structured fields
  final String name;
  final String jobTitle;
  final String company;
  final String email;
  final String phone;
  final String website;

  const CardScannerState({
    this.image,
    this.extractedText = '',
    this.isScanned = false,
    this.isLoading = false,
    this.errorMessage,
    this.name = '',
    this.jobTitle = '',
    this.company = '',
    this.email = '',
    this.phone = '',
    this.website = '',
  });

  CardScannerState copyWith({
    XFile? Function()? image,
    String? extractedText,
    bool? isScanned,
    bool? isLoading,
    String? Function()? errorMessage,
    String? name,
    String? jobTitle,
    String? company,
    String? email,
    String? phone,
    String? website,
  }) {
    return CardScannerState(
      image: image != null ? image() : this.image,
      extractedText: extractedText ?? this.extractedText,
      isScanned: isScanned ?? this.isScanned,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
    );
  }
}

// Card Scanner State Controller
class CardScannerController extends StateNotifier<CardScannerState> {
  final CardsRepository _repository;
  final ImagePicker _picker = ImagePicker();

  CardScannerController(this._repository) : super(const CardScannerState());

  Future<void> scanCard() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        state = state.copyWith(image: () => pickedFile);
        await _extractText(pickedFile.path);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to capture image: $e',
      );
    }
  }

  Future<void> _extractText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);

      String cardDetails = '';
      final List<String> lines = [];
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final trimmed = line.text.trim();
          if (trimmed.isNotEmpty) {
            lines.add(trimmed);
            cardDetails += '$trimmed\n';
          }
        }
      }
      textRecognizer.close();

      // Parse structured details
      String email = '';
      String phone = '';
      String website = '';
      String name = '';
      String jobTitle = '';
      String company = '';

      final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
      // Look for web URL that doesn't contain @
      final webRegex = RegExp(r'(?:https?:\/\/)?(?:www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
      // Phone regex matching digits, dashes, spaces, parentheses, starting with + or digit
      final phoneRegex = RegExp(r'\+?[0-9][0-9\- \(\)\.]{7,20}');

      for (final line in lines) {
        // Find Email
        if (email.isEmpty) {
          final emailMatch = emailRegex.firstMatch(line);
          if (emailMatch != null) {
            email = emailMatch.group(0) ?? '';
            continue;
          }
        }

        // Find Website
        if (website.isEmpty && !line.contains('@')) {
          final webMatch = webRegex.firstMatch(line.toLowerCase());
          if (webMatch != null && (line.toLowerCase().contains('www.') || line.toLowerCase().contains('.com') || line.toLowerCase().contains('.org') || line.toLowerCase().contains('.net') || line.toLowerCase().contains('.io') || line.toLowerCase().contains('.co'))) {
            website = webMatch.group(0) ?? '';
            continue;
          }
        }

        // Find Phone
        if (phone.isEmpty) {
          final cleanLine = line.replaceAll(RegExp(r'[^\d\+\-\(\) ]'), '');
          // Phone should have at least 7 digits to prevent picking zip codes
          final digitCount = cleanLine.replaceAll(RegExp(r'[^\d]'), '').length;
          if (digitCount >= 7 && digitCount <= 15) {
            final phoneMatch = phoneRegex.firstMatch(line);
            if (phoneMatch != null) {
              phone = phoneMatch.group(0)?.trim() ?? '';
              continue;
            }
          }
        }
      }

      // Heuristics for Job Title, Company and Name
      final titleKeywords = [
        'manager', 'ceo', 'founder', 'director', 'vp', 'president', 
        'officer', 'consultant', 'engineer', 'developer', 'architect', 
        'partner', 'lead', 'specialist', 'executive', 'cmo', 'cto', 
        'coo', 'cfo', 'analyst', 'designer'
      ];
      final companyKeywords = [
        'inc', 'llc', 'corp', 'corporation', 'co', 'ltd', 'limited', 
        'group', 'solutions', 'systems', 'partners', 'industries', 
        'services', 'technologies', 'ventures', 'medical'
      ];

      for (final line in lines) {
        // Skip lines that have been mapped to email, website or phone
        if (line == email || line == phone || line == website) continue;
        if (emailRegex.hasMatch(line) || phoneRegex.hasMatch(line)) continue;

        final lowerLine = line.toLowerCase();
        
        // 1. Identify Job Title
        if (jobTitle.isEmpty && titleKeywords.any((keyword) => lowerLine.contains(keyword))) {
          jobTitle = line;
          continue;
        }

        // 2. Identify Company
        if (company.isEmpty && companyKeywords.any((keyword) => 
            lowerLine.split(RegExp(r'\s+')).contains(keyword) || 
            lowerLine.endsWith(' $keyword') || 
            lowerLine.endsWith('.$keyword'))) {
          company = line;
          continue;
        }
      }

      // 3. Identify Name
      // Heuristic: Name is typically the first or second non-empty line that doesn't match company, title, email, phone, web, or address
      for (final line in lines) {
        if (line == email || line == phone || line == website || line == jobTitle || line == company) continue;
        final cleanLine = line.replaceAll(RegExp(r'[^\d]'), '');
        // Skip address lines or phone numbers (lines with many digits)
        if (cleanLine.length > 5) continue;
        // Skip short noise
        if (line.trim().length < 3) continue;
        
        name = line;
        break;
      }

      state = state.copyWith(
        extractedText: cardDetails,
        name: name,
        jobTitle: jobTitle,
        company: company,
        email: email,
        phone: phone,
        website: website,
        isScanned: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Text extraction failed: $e',
      );
    }
  }

  Future<bool> saveCard({
    required String name,
    String? jobTitle,
    String? company,
    String? email,
    String? phone,
    String? website,
  }) async {
    if (name.isEmpty || state.extractedText.isEmpty) return false;
    state = state.copyWith(isLoading: true);
    try {
      await _repository.saveCard(
        name: name,
        jobTitle: jobTitle,
        company: company,
        email: email,
        phone: phone,
        website: website,
        details: state.extractedText,
        imagePath: state.image?.path,
      );
      state = const CardScannerState(); // Reset scanner state after save
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to save card: $e',
      );
      return false;
    }
  }

  void reset() {
    state = const CardScannerState();
  }
}

// Card Scanner Controller Provider
final cardScannerControllerProvider =
    StateNotifierProvider<CardScannerController, CardScannerState>((ref) {
  final repository = ref.watch(cardsRepositoryProvider);
  return CardScannerController(repository);
});
