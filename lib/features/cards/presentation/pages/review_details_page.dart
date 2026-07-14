import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardscan_app/features/cards/presentation/controllers/cards_providers.dart';
import 'package:cardscan_app/features/cards/presentation/pages/saved_cards_page.dart';

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
      final success = await ref.read(cardScannerControllerProvider.notifier).saveCard(
            name: name,
            jobTitle: _jobTitleController.text.trim(),
            company: _companyController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            website: _websiteController.text.trim(),
          );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact saved successfully!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SavedCardsPage()),
            (route) => false,
          );
        } else {
          final error = ref.read(cardScannerControllerProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? 'Failed to save contact.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
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
            onPressed: () {
              Navigator.pop(context);
              ref.read(cardScannerControllerProvider.notifier).scanCard();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retake', style: TextStyle(fontWeight: FontWeight.bold)),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card Preview Block
                _buildCardPreview(),
                const SizedBox(height: 24),

                // Name field
                _buildFieldLabel('Full Name'),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Job Title & Company
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Job Title'),
                          TextField(
                            controller: _jobTitleController,
                            decoration: const InputDecoration(
                              hintText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Company'),
                          TextField(
                            controller: _companyController,
                            decoration: const InputDecoration(
                              hintText: 'Company name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Email
                _buildFieldLabel('Email'),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'email@address.com',
                    prefixIcon: Icon(Icons.mail_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Phone
                _buildFieldLabel('Phone'),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '+1 (555) 000-0000',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Website
                _buildFieldLabel('Website'),
                TextField(
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'www.website.com',
                    prefixIcon: Icon(Icons.language_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Notes
                _buildFieldLabel('Notes'),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Add additional details or context...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Collapsible RAW OCR Verification
                _buildOcrPanel(),
              ],
            ),
          ),
          
          // Fixed Bottom Button Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.85),
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ),
              child: _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Save Contact',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return AspectRatio(
      aspectRatio: 1.75,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: widget.imagePath != null
                  ? Image.file(
                      File(widget.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCvP3wq0AoVuGJZywjjMsOmx2mXVsHhHgXVpR333CblM2-gWRNvz32hsjenS_xCO_tMPgZ8_wvtR5W85BeJD5KY4Jv3CLOUbYVE04dS77QTvVb9xWzFe8GgTaSfMOYbsBDHLev7PmoiOFjIJV9av4cRttsRsMOoWGBgAso2pSLLu1gxqj4gSOq4L7GV3_bteoB7c2vKEhtoeeNzF31azt48FcHrRvEylzydN4qZEkwGUC9JRP7umRpDBQ',
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                ),
                child: Text(
                  'Card Scan Preview',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOcrPanel() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        InkWell(
          onTap: () {
            setState(() => _isOcrVisible = !_isOcrVisible);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'RAW OCR VERIFICATION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.outline,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isOcrVisible ? Icons.expand_less : Icons.expand_more,
                  color: colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          child: _isOcrVisible
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rawOcrText,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          height: 1.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '[CONFIDENCE SCORE: 98.4%]',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
