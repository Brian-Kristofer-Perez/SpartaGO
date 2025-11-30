import 'package:flutter/material.dart';
import 'package:sparta_go/common/back_button.dart';

class FAQsPage extends StatelessWidget {
  const FAQsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.fitness_center,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              CustomBackButton(),
              
              const Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'GYM Reservation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildFAQItem('1. How do I reserve a gym facility?'),
              _buildFAQItem('2. Can I edit or cancel my reservation?'),
              _buildFAQItem('3. Is there a limit to the number of reservations per day?'),

              const SizedBox(height: 20),

              const Text(
                'Equipment Borrowing',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildFAQItem('1. How long can I borrow equipment?'),
              _buildFAQItem('2. What happens if I return equipment late?'),
              _buildFAQItem('3. How do I check equipment availability?'),

              const SizedBox(height: 20),

              const Text(
                'Account & App Usage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildFAQItem('1. Why can\'t I log in?'),
              _buildFAQItem('2. How can I change my password?'),
              _buildFAQItem('3. Can I borrow equipment without a reservation?'),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        question,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          height: 1.5,
        ),
      ),
    );
  }
}