import 'package:flutter/material.dart';

class NodeWidget<T> extends StatelessWidget {
  final T data;
  final double size;
  final Color color;
  final Color textColor;
  final EdgeInsets margin;

  const NodeWidget({
    Key key,
    @required this.data,
    this.color = Colors.transparent,
    this.textColor = Colors.white,
    this.size = 30.0,
    this.margin = const EdgeInsets.only(right: 1.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: color,
      margin: margin,
      child: Center(
        child: Text(
          '$data',
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
