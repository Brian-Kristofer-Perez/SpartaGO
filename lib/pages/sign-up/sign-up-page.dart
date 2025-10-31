import 'package:flutter/material.dart';
import 'package:sparta_go/Repositories/UserRepository.dart';
import 'package:sparta_go/common/app-button.dart';
import 'package:sparta_go/common/custom-form-input.dart';
import 'package:sparta_go/common/hollow-app-button.dart';
import 'package:sparta_go/pages/login/login-page.dart';

import '../../services/UserService.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int currentStep = 0;
  
  // Controllers for form inputs
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Error messages
  String? fullNameError;
  String? emailError;
  String? studentNumberError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    studentNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation functions
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidStudentNumber(String number) {
    final numberRegex = RegExp(r'^\d{2}-\d{5}$');
    return numberRegex.hasMatch(number);
  }

  String? validateFullName(String value) {
    if (value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validateStudentNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter your student/employee number';
    }
    if (!isValidStudentNumber(value)) {
      return 'Please enter a valid student/employee number';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
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
    bool isValid = false;

    if (currentStep == 0) {
      isValid = validateStep0();
    } else if (currentStep == 1) {
      isValid = validateStep1();
    } else {
      isValid = true;
    }

    if (isValid && currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
        // Clear errors when going back
        if (currentStep == 0) {
          passwordError = null;
          confirmPasswordError = null;
        }
      });
    }
  }

  Widget buildStepIndicator(int step, String label, bool isCompleted, bool isCurrent) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted 
                ? Theme.of(context).colorScheme.primary
                : isCurrent
                    ? Colors.white
                    : Colors.white,
            border: Border.all(
              color: isCompleted || isCurrent
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 28)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isCurrent
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[400],
                    ),
                  ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isCompleted || isCurrent ? Colors.black : Colors.grey[400],
          ),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Image.asset(
                'assets/images/logo.png',
                height: 140,
              ),
              SizedBox(height: 18),
              Text(
                "Join SpartaGo",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Create your account to access gym facilities",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 32),
              
              // Step Indicators
              Center( 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildStepIndicator(0, 'Account Info', currentStep > 0, currentStep == 0),
                    SizedBox(width: 50),
                    buildStepIndicator(1, 'Credentials', currentStep > 1, currentStep == 1),
                    SizedBox(width: 57),
                    buildStepIndicator(2, 'Complete', false, currentStep == 2),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Step Content
              _buildStepContent(),
              
              SizedBox(height: 30),
              
              // Navigation Buttons
              _buildNavigationButtons(),
              SizedBox(height: 20),
              
              // Sign In Link (only on first step)
              if (currentStep == 0)
                Column(
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 13),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign in
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage()
                          )
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildAccountInfoStep();
      case 1:
        return _buildCredentialsStep();
      case 2:
        return _buildCompleteStep();
      default:
        return Container();
    }
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
                  CustomFormInput(
                    label: 'Full Name',
                    controller: fullNameController,
                  ),
                  if (fullNameError != null)
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 4),
                      child: Text(
                        fullNameError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormInput(
                    label: 'Email Address',
                    controller: emailController,
                  ),
                  if (emailError != null)
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 4),
                      child: Text(
                        emailError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormInput(
              label: 'Student/Employee Number',
              controller: studentNumberController,
            ),
            if (studentNumberError != null)
              Padding(
                padding: EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  studentNumberError!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                  ),
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
              label: 'Create Password',
              isPassword: true,
              controller: passwordController,
            ),
            if (passwordError != null)
              Padding(
                padding: EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  passwordError!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormInput(
              label: 'Confirm Password',
              isPassword: true,
              controller: confirmPasswordController,
            ),
            if (confirmPasswordError != null)
              Padding(
                padding: EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  confirmPasswordError!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompleteStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        Text(
          "Welcome to SpartaGo!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Your account has been created successfully. You can now access all gym facilities and equipment.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    if (currentStep == 2) {
      return Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: previousStep,
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              label: Text(
                'Back',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: AppButton(
              onPressed: () async {
                print('Name: ${fullNameController.text}');
                print('Email: ${emailController.text}');
                print('Student Number: ${studentNumberController.text}');
                print('Password: ${passwordController.text}');

                // Validation: Check if email already exists
                UserRepository repo = UserRepository();
                Map<String, dynamic>? user = await repo.getByEmail(emailController.text);

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email already exists. Use a valid email!')),
                  );
                  return;
                }

                // TODO: add other validation steps
                await UserService().register(
                    name: fullNameController.text,
                    email: emailController.text,
                    studentNumber: studentNumberController.text,
                    password: passwordController.text
                );


                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User registration successful!')),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()
                  )
                );
              },
              children: [
                Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: TextButton.icon(
              onPressed: previousStep,
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              label: Text(
                'Back',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (currentStep > 0) SizedBox(width: 16),
        Expanded(
          child: AppButton(
            onPressed: nextStep,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}