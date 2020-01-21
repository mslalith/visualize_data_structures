import 'package:flutter/material.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';

class FluentButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  FluentButton({
    @required this.text,
    @required this.onPressed,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
  })  : assert(text != null, 'FluentButton: text is null'),
        assert(onPressed != null, 'FluentButton: onTap is null');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? buttonColor,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onPressed,
        child: Container(
          padding: padding,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
