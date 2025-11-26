import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sparta_go/common/app-button.dart';
import 'package:sparta_go/common/custom-form-input.dart';
import 'package:sparta_go/pages/login/login-page.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int currentStep = 0;

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Errors
  String? fullNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
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
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) return 'Please enter your email address';
    if (!isValidEmail(value)) return 'Please enter a valid email';
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
    });

    return fullNameError == null &&
        emailError == null;
  }

  bool validateStep1() {
    setState(() {
      passwordError = validatePassword(passwordController.text);
      confirmPasswordError =
          validateConfirmPassword(confirmPasswordController.text);
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

  final String apiBase = "http://10.0.2.2:8080/users/register";  

  Future<bool> checkEmailExists(String email) async {
    final url = Uri.parse('$apiBase/users/check-email');

    final response = await http.post(
      url,
      body: jsonEncode({"email": email}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["exists"] == true;
    }

    return false;
  }

  Future<bool> registerUser() async {
    final url = Uri.parse('$apiBase/users/register');

    final body = {
      "name": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    return response.statusCode == 201; // success
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
            color: done
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
            border: Border.all(
              color: done || current
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: done
                ? Icon(Icons.check, color: Colors.white, size: 28)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      color: current
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              SizedBox(height: 80),
              Image.asset('assets/images/logo.png', height: 140),
              SizedBox(height: 20),
              Text("Join SpartaGo",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary)),
              SizedBox(height: 30),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildStepIndicator(0, "Account Info", currentStep > 0, currentStep == 0),
                  SizedBox(width: 60),
                  buildStepIndicator(1, "Credentials", currentStep > 1, currentStep == 1),
                  SizedBox(width: 60),
                  buildStepIndicator(2, "Complete", false, currentStep == 2),
                ],
              ),

              SizedBox(height: 30),
              _buildStepContent(),
              SizedBox(height: 30),
              _buildNavigationButtons(),
            ],
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
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormInput(label: "Full Name", controller: fullNameController),
                  if (fullNameError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(fullNameError!, style: TextStyle(color: Colors.red, fontSize: 11)),
                    ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormInput(label: "Email Address", controller: emailController),
                  if (emailError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(emailError!, style: TextStyle(color: Colors.red, fontSize: 11)),
                    ),
                ],
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
                controller: passwordController),
            if (passwordError != null)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(passwordError!,
                    style: TextStyle(color: Colors.red, fontSize: 11)),
              ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormInput(
                label: "Confirm Password",
                isPassword: true,
                controller: confirmPasswordController),
            if (confirmPasswordError != null)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(confirmPasswordError!,
                    style: TextStyle(color: Colors.red, fontSize: 11)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompleteStep() {
    return Column(
      children: [
        SizedBox(height: 50),
        Text("Welcome to SpartaGo!",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary)),
        SizedBox(height: 20),
        Text(
          "Your account has been created successfully!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
        children: [
          Text("Go to Login", style: TextStyle(color: Colors.white)),
        ],
      );
    }

    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: TextButton(
              onPressed: previousStep,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 20),
                  SizedBox(width: 6),
                  Text("Back"),
                ],
              ),
            ),
          ),
        if (currentStep > 0) SizedBox(width: 20),
        Expanded(
          child: AppButton(
            onPressed: () async {
              if (currentStep < 1) return nextStep();

              if (!validateStep1()) return;

              // -----------------------------------
              // Check Email
              // -----------------------------------
              bool exists = await checkEmailExists(emailController.text.trim());

              if (exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email already exists")),
                );
                return;
              }

              // -----------------------------------
              // Register User
              // -----------------------------------
              bool success = await registerUser();

              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Registration failed")),
                );
                return;
              }

              setState(() {
                currentStep = 2;
              });
            },
            children: [
              Text("Continue",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}
