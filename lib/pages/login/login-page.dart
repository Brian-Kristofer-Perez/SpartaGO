
import 'package:flutter/material.dart';
import 'package:sparta_go/common/app-button.dart';
import 'package:sparta_go/common/custom-form-input.dart';
import 'package:sparta_go/common/hollow-app-button.dart';
import 'package:sparta_go/pages/login/sign-as-admin.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 140,
              ),

              SizedBox(height: 18,),

              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.secondary
                ),
              ),

              SizedBox(height: 6,),

              Text(
                "Sign in to gain access to your SpartaGo account",
                style: TextStyle(
                  fontSize: 13,
                )
              ),

              SizedBox(height: 32),

              CustomFormInput(label: "Email or Student/Employee Number"),

              SizedBox(height: 16,),

              CustomFormInput(label: "Password", isPassword: true,),

              SizedBox(height: 28,),

              AppButton(
                  children: [
                    Text(
                      "Log in",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 20
                      ),
                    )
                  ],
                  onPressed: (){}
              ),

              SizedBox(height: 10,),

              HollowAppButton(
                text: "Create a new account",
                onPressed: () {},
              ),

              SizedBox(height: 10,),

              AdminSignIn()
            ]
          ),
        )
    );
  }
}
