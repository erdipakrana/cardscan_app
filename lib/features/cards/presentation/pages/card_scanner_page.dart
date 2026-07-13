import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardscan_app/features/cards/presentation/controllers/cards_providers.dart';
import 'package:cardscan_app/features/cards/presentation/pages/saved_cards_page.dart';

class CardScannerPage extends ConsumerStatefulWidget {
  const CardScannerPage({super.key});

  @override
  ConsumerState<CardScannerPage> createState() => _CardScannerPageState();
}

class _CardScannerPageState extends ConsumerState<CardScannerPage> {

  @override
  void initState() {
    super.initState();
    // Reset scanner state when opening page
    Future.microtask(() {
      ref.read(cardScannerControllerProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Dialog to review and edit card fields before saving
  Future<void> _showSaveDialog() async {
    final scannerState = ref.read(cardScannerControllerProvider);
    
    final nameController = TextEditingController(text: scannerState.name);
    final jobTitleController = TextEditingController(text: scannerState.jobTitle);
    final companyController = TextEditingController(text: scannerState.company);
    final emailController = TextEditingController(text: scannerState.email);
    final phoneController = TextEditingController(text: scannerState.phone);
    final websiteController = TextEditingController(text: scannerState.website);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Review & Save Contact'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Name *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: jobTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Job Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                nameController.dispose();
                jobTitleController.dispose();
                companyController.dispose();
                emailController.dispose();
                phoneController.dispose();
                websiteController.dispose();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a name.')),
                  );
                  return;
                }
                
                final jobTitle = jobTitleController.text.trim();
                final company = companyController.text.trim();
                final email = emailController.text.trim();
                final phone = phoneController.text.trim();
                final website = websiteController.text.trim();

                Navigator.of(context).pop();
                
                await _saveCard(
                  name: name,
                  jobTitle: jobTitle.isNotEmpty ? jobTitle : null,
                  company: company.isNotEmpty ? company : null,
                  email: email.isNotEmpty ? email : null,
                  phone: phone.isNotEmpty ? phone : null,
                  website: website.isNotEmpty ? website : null,
                );

                nameController.dispose();
                jobTitleController.dispose();
                companyController.dispose();
                emailController.dispose();
                phoneController.dispose();
                websiteController.dispose();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCard({
    required String name,
    String? jobTitle,
    String? company,
    String? email,
    String? phone,
    String? website,
  }) async {
    final success = await ref
        .read(cardScannerControllerProvider.notifier)
        .saveCard(
          name: name,
          jobTitle: jobTitle,
          company: company,
          email: email,
          phone: phone,
          website: website,
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card details saved!'),
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
            content: Text(error ?? 'Failed to save card.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(cardScannerControllerProvider);
    final scannerNotifier = ref.read(cardScannerControllerProvider.notifier);

    // Watch for error messages and display snackbars
    ref.listen<CardScannerState>(cardScannerControllerProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Visiting Card'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Image Container / Preview
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  image: scannerState.image != null
                      ? DecorationImage(
                          image: kIsWeb
                              ? NetworkImage(scannerState.image!.path) as ImageProvider
                              : FileImage(File(scannerState.image!.path)),
                          fit: BoxFit.contain,
                        )
                      : null,
                ),
                child: scannerState.image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No image captured yet',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
              const SizedBox(height: 24),

              // Action buttons (Scan / Save)
              if (scannerState.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: scannerNotifier.scanCard,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Scan Card'),
                      ),
                    ),
                    if (scannerState.extractedText.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _showSaveDialog,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Save Card'),
                        ),
                      ),
                    ]
                  ],
                ),
              const SizedBox(height: 24),

              // Extracted Text Display Area
              if (scannerState.extractedText.isNotEmpty) ...[
                Text(
                  'Extracted Text:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: SelectableText(
                    scannerState.extractedText,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ] else if (scannerState.isScanned &&
                  scannerState.extractedText.isEmpty)
                const Text(
                  'No text was detected on the card. Try again in better lighting.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.orange, height: 1.4),
                )
              else if (!scannerState.isScanned)
                const Text(
                  'Scan a visiting card using your camera to automatically extract contact details.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, height: 1.4),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
