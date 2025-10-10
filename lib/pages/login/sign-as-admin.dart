import 'package:flutter/material.dart';

class AdminSignIn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Sign In',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.brown, // Adjust the color as needed
          ),
        ),

        SizedBox(width: 8), // Space between the texts

        Text(
          'as SpartGO Admin',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black, // Adjust the color as needed
          ),
        ),
      ],
    );
  }
}