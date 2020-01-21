import 'package:flutter/material.dart';

class ClickableIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final bool isVisible;

  const ClickableIcon({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.iconSize = 19.0,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      type: MaterialType.button,
      shape: CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isVisible ? 40.0 : 0.0,
          height: isVisible ? 40.0 : 0.0,
          padding: const EdgeInsets.all(8.0),
          color: backgroundColor,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
