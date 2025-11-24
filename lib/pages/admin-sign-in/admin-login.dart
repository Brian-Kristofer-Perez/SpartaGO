import 'package:flutter/material.dart';
import 'package:sparta_go/common/app-button.dart';
import 'package:sparta_go/common/custom-form-input.dart';
import 'package:sparta_go/pages/login/login-page.dart';
import 'package:sparta_go/pages/admin-user_manager/user_manager.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController adminIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  String? adminIdError;
  String? passwordError;

  @override
  void dispose() {
    adminIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateAdminId(String value) {
    if (value.isEmpty) {
      return 'Please enter your Admin UserID';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void handleAdminLogin() {
    setState(() {
      adminIdError = validateAdminId(adminIdController.text.trim());
      passwordError = validatePassword(passwordController.text);
    });

    if (adminIdError == null && passwordError == null) {
      // TODO: Add admin authentication logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin login successful')),
      );

      // Navigate to Admin Dashboard (User Manager)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserManagerPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.fitness_center,
                      color: Colors.red,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  const Text(
                    'Sparta Gymnasium Organizer',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  const Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    'Sign in to access your Admin account',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Admin UserID Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFormInput(
                        label: 'Admin UserID',
                        controller: adminIdController,
                      ),
                      if (adminIdError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 4),
                          child: Text(
                            adminIdError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFormInput(
                        label: 'Password',
                        isPassword: true,
                        controller: passwordController,
                      ),
                      if (passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 4),
                          child: Text(
                            passwordError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Sign In Button
                  AppButton(
                    onPressed: handleAdminLogin,
                    children: const [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // User Sign In Link
                  Column(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: const Color(0xFF8B1E1E),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'User Sign In',
                          style: TextStyle(
                            color: Color(0xFF8B1E1E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}