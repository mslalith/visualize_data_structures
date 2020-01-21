import 'package:flutter/material.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';

import 'clickable_icon.dart';

class InfoEditWidget extends StatefulWidget {
  final Widget infoChild;
  final Widget editChild;
  final IconData icon;
  final Color color;

  InfoEditWidget({
    Key key,
    @required this.infoChild,
    @required this.editChild,
    @required this.icon,
    color,
  })  : color = color ?? backgroundHighlighter,
        super(key: key);

  @override
  _InfoEditWidgetState createState() => _InfoEditWidgetState();
}

class _InfoEditWidgetState extends State<InfoEditWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Size size = Size.zero;
  Widget editChild;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.infoChild,
                SizedBox(width: 4.0),
                ClickableIcon(
                  icon: isVisible ? Icons.done : widget.icon,
                  onPressed: toggleEditChild,
                ),
              ],
            ),
          ),
          SizeTransition(
            axisAlignment: -1,
            sizeFactor: controller,
            child: Container(
              height: 35.0,
              child: widget.editChild,
            ),
          ),
        ],
      ),
    );
  }

  void toggleEditChild() {
    if (isVisible)
      controller.reverse();
    else
      controller.forward();
  }

  bool get isVisible =>
      controller.status == AnimationStatus.forward ||
      controller.status == AnimationStatus.completed;
}
