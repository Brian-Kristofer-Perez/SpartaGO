import 'package:flutter/material.dart';
import 'package:sparta_go/common/app-button.dart';
import 'package:sparta_go/common/custom-form-input.dart';
import 'package:sparta_go/common/hollow-app-button.dart';

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

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    studentNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (currentStep < 2) {
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
              child: CustomFormInput(
                label: 'Full Name',
                controller: fullNameController,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: CustomFormInput(
                label: 'Email Address',
                controller: emailController,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        CustomFormInput(
          label: 'Student/Employee Number',
          controller: studentNumberController,
        ),
      ],
    );
  }

  Widget _buildCredentialsStep() {
    return Column(
      children: [
        CustomFormInput(
          label: 'Create Password',
          isPassword: true,
          controller: passwordController,
        ),
        SizedBox(height: 20),
        CustomFormInput(
          label: 'Confirm Password',
          isPassword: true,
          controller: confirmPasswordController,
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
              onPressed: () {
                // Navigate to home or dashboard
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