
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {

  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () { Navigator.pop(context, true); },
      icon: const Icon(Icons.arrow_back),
      label: const Text('Back'),
    );
  }
}