import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardscan_app/features/cards/presentation/controllers/cards_providers.dart';
import 'package:cardscan_app/features/cards/presentation/pages/saved_cards_page.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/review_card_preview.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/review_contact_form.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/review_ocr_panel.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/review_save_bar.dart';

class ReviewDetailsPage extends ConsumerStatefulWidget {
  const ReviewDetailsPage({
    super.key,
    this.imagePath,
    required this.initialName,
    required this.initialJobTitle,
    required this.initialCompany,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialWebsite,
    required this.rawOcrText,
  });

  final String? imagePath;
  final String initialName;
  final String initialJobTitle;
  final String initialCompany;
  final String initialEmail;
  final String initialPhone;
  final String initialWebsite;
  final String rawOcrText;

  @override
  ConsumerState<ReviewDetailsPage> createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends ConsumerState<ReviewDetailsPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _companyController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;
  late final TextEditingController _notesController;

  bool _isOcrVisible = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _jobTitleController = TextEditingController(text: widget.initialJobTitle);
    _companyController = TextEditingController(text: widget.initialCompany);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _websiteController = TextEditingController(text: widget.initialWebsite);
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _ReviewDetailsAppBar(onRetake: _handleRetake),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ReviewCardPreview(imagePath: widget.imagePath),
                const SizedBox(height: 24),
                ReviewContactForm(
                  nameController: _nameController,
                  jobTitleController: _jobTitleController,
                  companyController: _companyController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  websiteController: _websiteController,
                  notesController: _notesController,
                ),
                const SizedBox(height: 24),
                ReviewOcrPanel(
                  rawOcrText: widget.rawOcrText,
                  isVisible: _isOcrVisible,
                  onToggleVisibility: _toggleOcrVisibility,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ReviewSaveBar(isSaving: _isSaving, onSave: _handleSave),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a contact name.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await ref
          .read(cardScannerControllerProvider.notifier)
          .saveCard(
            name: name,
            jobTitle: _jobTitleController.text.trim(),
            company: _companyController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            website: _websiteController.text.trim(),
          );

      if (!mounted) return;

      if (success) {
        _showSuccessMessage();
        _navigateToSavedCards();
      } else {
        _showSaveError();
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _handleRetake() {
    Navigator.pop(context);
    ref.read(cardScannerControllerProvider.notifier).scanCard();
  }

  void _toggleOcrVisibility() {
    setState(() => _isOcrVisible = !_isOcrVisible);
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact saved successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSaveError() {
    final error = ref.read(cardScannerControllerProvider).errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Failed to save contact.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navigateToSavedCards() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SavedCardsPage()),
      (route) => false,
    );
  }
}

class _ReviewDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ReviewDetailsAppBar({required this.onRetake});

  final VoidCallback onRetake;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: colorScheme.primary,
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Text(
        'Review Details',
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: onRetake,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text(
            'Retake',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
