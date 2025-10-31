import 'package:flutter/material.dart';
import 'package:sparta_go/common/app-button.dart';
import 'package:sparta_go/common/custom-form-input.dart';
import 'package:sparta_go/common/hollow-app-button.dart';
import 'package:sparta_go/pages/facilities/facilities.dart';
import 'package:sparta_go/pages/login/sign-as-admin.dart';
import 'package:sparta_go/pages/sign-up/sign-up-page.dart';
import 'package:sparta_go/services/UserService.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

  String? validateEmailOrStudentNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter your email or student/employee number';
    }
    
    if (value.contains('@')) {
      if (!isValidEmail(value)) {
        return 'Please enter a valid email address';
      }
    } else {
      if (!isValidStudentNumber(value)) {
        return 'Please enter a valid student/employee number';
      }
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

  void handleLogin() async {
    setState(() {
      emailError = validateEmailOrStudentNumber(emailController.text.trim());
      passwordError = validatePassword(passwordController.text);
    });

    if (emailError == null && passwordError == null) {

      UserService service = UserService();

      // try {
        await service.log_in(email: emailController.text, password: passwordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FacilitiesPage()
          )
        );
      // }
      // catch (e) {
      //   final String message = e.toString().replaceFirst('Exception: ', '');
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(message)),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 140,
            ),
            SizedBox(height: 18),
            Text(
              "Welcome",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Sign in to gain access to your SpartaGo account",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 32),
            
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFormInput(
                  label: "Email or Student/Employee Number",
                  controller: emailController,
                ),
                if (emailError != null)
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 4),
                    child: Text(
                      emailError!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: 16),
            
          
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFormInput(
                  label: "Password",
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
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: 28),
            
            AppButton(
              children: [
                Text(
                  "Log in",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 20,
                  ),
                ),
              ],
              onPressed: handleLogin,
            ),
            
            SizedBox(height: 10),
            
            HollowAppButton(
              text: "Create a new account",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPage()
                  )
                );
              },
            ),
            
            SizedBox(height: 10),
            
            AdminSignIn(),
          ],
        ),
      ),
    );
  }
}