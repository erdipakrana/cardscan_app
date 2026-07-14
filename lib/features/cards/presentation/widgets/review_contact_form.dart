import 'package:flutter/material.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/review_text_field.dart';

class ReviewContactForm extends StatelessWidget {
  const ReviewContactForm({
    super.key,
    required this.nameController,
    required this.jobTitleController,
    required this.companyController,
    required this.emailController,
    required this.phoneController,
    required this.websiteController,
    required this.notesController,
  });

  final TextEditingController nameController;
  final TextEditingController jobTitleController;
  final TextEditingController companyController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController websiteController;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReviewTextField(
          label: 'Full Name',
          controller: nameController,
          hintText: 'Enter name',
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ReviewTextField(
                label: 'Job Title',
                controller: jobTitleController,
                hintText: 'Title',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ReviewTextField(
                label: 'Company',
                controller: companyController,
                hintText: 'Company name',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ReviewTextField(
          label: 'Email',
          controller: emailController,
          hintText: 'email@address.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outlined,
        ),
        const SizedBox(height: 20),
        ReviewTextField(
          label: 'Phone',
          controller: phoneController,
          hintText: '+1 (555) 000-0000',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
        ),
        const SizedBox(height: 20),
        ReviewTextField(
          label: 'Website',
          controller: websiteController,
          hintText: 'www.website.com',
          keyboardType: TextInputType.url,
          prefixIcon: Icons.language_outlined,
        ),
        const SizedBox(height: 20),
        ReviewTextField(
          label: 'Notes',
          controller: notesController,
          hintText: 'Add additional details or context...',
          maxLines: 3,
        ),
      ],
    );
  }
}
