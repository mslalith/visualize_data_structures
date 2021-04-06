import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';

class ExpandedWidget<T> extends StatefulWidget {
  final double openWidth;
  final double closeWidth;
  final Widget title;
  final List<T> children;
  final Widget Function(T) builder;
  final bool animatedBackgroundColor;
  final Color? backgroundColor;
  final Color dividerColor;
  final Color iconColor;
  final bool shouldExpand;

  ExpandedWidget({
    Key? key,
    required openWidth,
    closeWidth,
    required this.title,
    required this.children,
    required this.builder,
    this.animatedBackgroundColor = false,
    this.backgroundColor,
    dividerColor,
    this.shouldExpand = true,
    this.iconColor = Colors.white,
  })  : dividerColor = dividerColor ?? Colors.white.withOpacity(0.8),
        openWidth = shouldExpand ? openWidth : 300.0,
        closeWidth = closeWidth ?? openWidth,
        super(key: key);

  @override
  _ExpandedWidgetState<T> createState() => _ExpandedWidgetState<T>();
}

class _ExpandedWidgetState<T> extends State<ExpandedWidget<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _openCloseAnimationController;
  bool isOpened = false;

  @override
  void initState() {
    super.initState();
    _openCloseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => setState(() {}));
    if (!widget.shouldExpand) {
      _openCloseAnimationController.forward();
      isOpened = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.animatedBackgroundColor
        ? Colors.white.withOpacity(isOpened ? 0.16 : 0.0)
        : widget.backgroundColor ?? importantColor;

    BorderRadius borderRadius = widget.animatedBackgroundColor
        ? BorderRadius.circular(isOpened ? 8.0 : 0.0)
        : BorderRadius.circular(8.0);

    return AnimatedContainer(
      width: isOpened ? widget.openWidth : widget.closeWidth,
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: EdgeInsets.only(
        top: isOpened ? 8.0 : 0.0,
        bottom: isOpened ? 8.0 : 0.0,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: _toggleSelected,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.title,
                  Spacer(),
                  if (widget.shouldExpand)
                    Transform.rotate(
                      angle: pi * _openCloseAnimationController.value,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.iconColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _openCloseAnimationController,
            axisAlignment: -1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(
                    thickness: 1.0,
                    indent: 16.0,
                    endIndent: 16.0,
                    color: widget.dividerColor,
                  ),
                  for (T data in widget.children) widget.builder(data)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSelected() {
    if (!widget.shouldExpand) return;
    setState(() {
      isOpened = !isOpened;
      if (isOpened)
        _openCloseAnimationController.forward();
      else
        _openCloseAnimationController.reverse();
    });
  }
}
