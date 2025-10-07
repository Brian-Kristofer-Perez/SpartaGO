import 'package:flutter/material.dart';

class CustomFormInput extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomFormInput({
    super.key,
    required this.label,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child:
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            cursorColor: Theme.of(context).colorScheme.secondary,
            style: TextStyle(
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
