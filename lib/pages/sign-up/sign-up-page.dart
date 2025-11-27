import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sparta_go/common/app-button.dart';
import 'package:sparta_go/common/custom-form-input.dart';
import 'package:sparta_go/pages/login/login-page.dart';
import 'package:sparta_go/constant/constant.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int currentStep = 0;

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Errors
  String? fullNameError;
  String? emailError;
  String? studentNumberError;
  String? passwordError;
  String? confirmPasswordError;

  // Loading state
  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    studentNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // -----------------------------------
  // VALIDATION
  // -----------------------------------

  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  String? validateFullName(String value) {
    if (value.isEmpty) return 'Please enter your full name';
    if (value.length < 2) return 'Name must be at least 2 characters';
    // Check if it contains at least first and last name
    if (!value.trim().contains(' ')) {
      return 'Please enter both first and last name';
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) return 'Please enter your email address';
    if (!isValidEmail(value)) return 'Please enter a valid email';
    return null;
  }

  String? validateStudentNumber(String value) {
    if (value.isEmpty) return 'Please enter your student/employee number';
    if (value.length < 4) return 'Number must be at least 4 characters';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Please enter a password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain 1 uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain 1 lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain 1 number';
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  bool validateStep0() {
    setState(() {
      fullNameError = validateFullName(fullNameController.text.trim());
      emailError = validateEmail(emailController.text.trim());
      studentNumberError = validateStudentNumber(studentNumberController.text.trim());
    });

    return fullNameError == null && emailError == null && studentNumberError == null;
  }

  bool validateStep1() {
    setState(() {
      passwordError = validatePassword(passwordController.text);
      confirmPasswordError = validateConfirmPassword(confirmPasswordController.text);
    });

    return passwordError == null && confirmPasswordError == null;
  }

  void nextStep() {
    bool valid = false;

    if (currentStep == 0) valid = validateStep0();
    if (currentStep == 1) valid = validateStep1();
    if (currentStep == 2) valid = true;

    if (valid && currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  // -----------------------------------
  // HTTP REQUESTS
  // -----------------------------------

  // POST /users/register
  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      print('🔄 Registering user...');

      // Split full name into first and last name
      final nameParts = fullNameController.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : nameParts.first;

      final body = {
        "firstName": firstName,
        "lastName": lastName,
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      print('📤 Request body: $body');

      final response = await http.post(
        Uri.parse('{$API_URL}/users/register'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse boolean response
        final bool success = json.decode(response.body);

        if (success) {
          print('✅ Registration successful');

          setState(() {
            currentStep = 2; // Move to completion step
          });
        } else {
          print('❌ Registration failed: API returned false');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration failed. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        print('❌ Registration failed: ${response.statusCode}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error during registration: $e');

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // -----------------------------------
  // UI START
  // -----------------------------------

  Widget buildStepIndicator(int step, String label, bool done, bool current) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? const Color(0xFF8B1E1E) : Colors.white,
            border: Border.all(
              color: done || current ? const Color(0xFF8B1E1E) : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: current ? const Color(0xFF8B1E1E) : Colors.grey.shade400,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: done || current ? Colors.black87 : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.fitness_center,
                    color: Colors.red,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Join SpartaGO",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create your account to access gym facilities",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 40),

                // Step Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildStepIndicator(0, "Account Info", currentStep > 0, currentStep == 0),
                    Container(
                      width: 40,
                      height: 2,
                      color: currentStep > 0 ? const Color(0xFF8B1E1E) : Colors.grey.shade300,
                    ),
                    buildStepIndicator(1, "Credentials", currentStep > 1, currentStep == 1),
                    Container(
                      width: 40,
                      height: 2,
                      color: currentStep > 1 ? const Color(0xFF8B1E1E) : Colors.grey.shade300,
                    ),
                    buildStepIndicator(2, "Complete", false, currentStep == 2),
                  ],
                ),

                const SizedBox(height: 40),
                _buildStepContent(),
                const SizedBox(height: 30),
                _buildNavigationButtons(),
                const SizedBox(height: 20),
                
                // Sign In Link
                if (currentStep < 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8B1E1E),
                            fontWeight: FontWeight.bold,
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
    );
  }

  // -----------------------------------
  // STEP CONTENTS
  // -----------------------------------

  Widget _buildStepContent() {
    if (currentStep == 0) return _buildAccountInfoStep();
    if (currentStep == 1) return _buildCredentialsStep();
    return _buildCompleteStep();
  }

  Widget _buildAccountInfoStep() {
    return Column(
      children: [
        // Full Name and Email in a Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormInput(
                    label: "Full Name",
                    controller: fullNameController,
                  ),
                  if (fullNameError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 4),
                      child: Text(
                        fullNameError!,
                        style: const TextStyle(color: Colors.red, fontSize: 10),
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
                  CustomFormInput(
                    label: "Email Address",
                    controller: emailController,
                  ),
                  if (emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 4),
                      child: Text(
                        emailError!,
                        style: const TextStyle(color: Colors.red, fontSize: 10),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Student/Employee Number (Full Width)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormInput(
              label: "Student/Employee Number",
              controller: studentNumberController,
            ),
            if (studentNumberError != null)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  studentNumberError!,
                  style: const TextStyle(color: Colors.red, fontSize: 10),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCredentialsStep() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormInput(
              label: "Create Password",
              isPassword: true,
              controller: passwordController,
            ),
            if (passwordError != null)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  passwordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 10),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormInput(
              label: "Confirm Password",
              isPassword: true,
              controller: confirmPasswordController,
            ),
            if (confirmPasswordError != null)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  confirmPasswordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 10),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompleteStep() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Icon(
          Icons.check_circle_outline,
          size: 100,
          color: Color(0xFF8B1E1E),
        ),
        const SizedBox(height: 20),
        const Text(
          "Welcome to SpartaGo!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Your account has been created successfully!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // -----------------------------------
  // BUTTONS
  // -----------------------------------

  Widget _buildNavigationButtons() {
    if (currentStep == 2) {
      return AppButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
        },
        children: const [
          Text(
            "Go to Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return AppButton(
      onPressed: _handleContinueWrapper,
      children: [
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        else ...[
          const Text(
            "Continue",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
        ],
      ],
    );
  }

  void _handleContinueWrapper() {
    if (!isLoading) {
      _handleContinue();
    }
  }

  void _handleContinue() {
    // Step 0: Validate account info
    if (currentStep == 0) {
      if (validateStep0()) {
        nextStep();
      }
      return;
    }

    // Step 1: Validate credentials and register
    if (currentStep == 1) {
      if (validateStep1()) {
        // Call registration API
        registerUser();
      }
      return;
    }
  }
}