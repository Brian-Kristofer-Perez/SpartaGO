
import 'package:flutter/material.dart';

class ProgressItem extends StatefulWidget {

  final int currentStep;
  final int number;
  final String label;

  ProgressItem({
    super.key,
    required this.number,
    required this.currentStep,
    required this.label
  });

  @override
  State<StatefulWidget> createState() => _ProgressItemState();
}

class _ProgressItemState extends State<ProgressItem>{

  @override
  Widget build(BuildContext context) {

    var child;
    final String label;
    final Color borderColor;
    final Color bgColor;
    final Color labelColor;

    final Color textColor = widget.currentStep >= widget.number
      ? Theme.of(context).colorScheme.primary
      : Colors.black;

    const Icon checkContent = Icon(
      Icons.check,
      size: 24,
      color: Colors.white,
    );

    final Text numberContent = Text(
        "${widget.number}",
        style: TextStyle(
          // fontFamily:
          fontSize: 24,
          color: textColor
        )
    );


    // done state
    if(widget.currentStep > widget.number){
      borderColor = Theme.of(context).colorScheme.primary;
      bgColor = Theme.of(context).colorScheme.primary;
      labelColor = Theme.of(context).colorScheme.secondary;
      child = checkContent;
    }

    // current state
    else if(widget.currentStep == widget.number){
      borderColor = Theme.of(context).colorScheme.primary;
      bgColor = Theme.of(context).colorScheme.primaryContainer;
      labelColor = Theme.of(context).colorScheme.primary;
      child = numberContent;
    }

    // not yet done state
    else {
      borderColor = Theme.of(context).colorScheme.outline;
      bgColor = Theme.of(context).colorScheme.background;
      labelColor = Theme.of(context).colorScheme.outline;
      child = numberContent;
    }

    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: Border.all(
                color: borderColor,
                width: 2
              )
          ),
          child: Center(
              child: child
          )
        ),
        Padding(
          padding: EdgeInsets.only(top: 7),
          child: Text(widget.label, style: TextStyle(fontSize: 13, color: borderColor),)
        )
      ]
    );
  }
}