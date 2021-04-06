import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/providers/topic_provider.dart';

import 'nav_item.dart';

class NavListItem extends StatefulWidget {
  final NavItem item;

  const NavListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _NavListItemState createState() => _NavListItemState();
}

class _NavListItemState extends State<NavListItem>
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
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          margin: EdgeInsets.only(
            top: isOpened ? 8.0 : 0.0,
            bottom: isOpened ? 8.0 : 0.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isOpened ? 0.16 : 0.0),
            borderRadius: BorderRadius.circular(isOpened ? 8.0 : 0.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: _toggleSelected,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Text(widget.item.name),
                      Expanded(child: Container()),
                      Transform.rotate(
                        angle: pi * _openCloseAnimationController.value,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizeTransition(
                sizeFactor: _openCloseAnimationController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 3.0),
                    Divider(
                      thickness: 1.0,
                      indent: 16.0,
                      endIndent: 16.0,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    for (String topic in widget.item.topics)
                      _SubTopicItem(
                        topic: topic,
                        onPressed: () => _onTopicSelected(
                          widget.item.name,
                          topic,
                          sizingInfo.isDesktop,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTopicSelected(String title, String topic, bool isDesktop) {
    if (!isDesktop) Navigator.of(context).pop();
    String name =
        title.toLowerCase() + '_' + topic.toLowerCase().replaceAll(' ', '_');
    Provider.of<TopicProvider>(context, listen: false).updateTopic(name);
  }

  void _toggleSelected() {
    setState(() {
      isOpened = !isOpened;
      if (isOpened)
        _openCloseAnimationController.forward();
      else
        _openCloseAnimationController.reverse();
    });
  }
}

class _SubTopicItem extends StatelessWidget {
  final String topic;
  final VoidCallback onPressed;

  const _SubTopicItem({
    Key? key,
    required this.topic,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 28.0,
            vertical: 11.0,
          ),
          child: Text(
            topic,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }
}
