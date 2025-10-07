
import 'package:flutter/material.dart';

class HollowAppButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  HollowAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.background,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 2
        )
      ),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20
            ),
          ),
        ],
      )
    );
  }
}