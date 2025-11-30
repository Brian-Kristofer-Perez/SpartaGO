import 'package:flutter/material.dart';
import 'package:sparta_go/common/back_button.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

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
                'About',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'App Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SpartaGo is a reservation platform designed for students and staff to easily book campus gym facilities and borrow equipment.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Mission',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'To provide a convenient and organized way to manage gym usage.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Features',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('1. Facility Reservation'),
              _buildFeatureItem('2. Equipment Borrowing'),
              _buildFeatureItem('3. Real-Time Availability Tracking'),
              _buildFeatureItem('4. Reservation History'),
              _buildFeatureItem('5. Notification Reminders'),

              const SizedBox(height: 24),

              const Text(
                'Developers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildDeveloperItem('Genrique Balmes'),
              _buildDeveloperItem('Angelyka De Castro'),
              _buildDeveloperItem('Lenard Panganiban'),
              _buildDeveloperItem('Brian Perez'),
              _buildDeveloperItem('Anda Vael'),

              const SizedBox(height: 24),

              const Text(
                'Supported by',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sean Segui',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        feature,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildDeveloperItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          height: 1.5,
        ),
      ),
    );
  }
}