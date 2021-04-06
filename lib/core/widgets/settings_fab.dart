import 'package:flutter/material.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/clickable_icon.dart';
import 'package:visualize_data_structures/core/widgets/fluent_button.dart';

class SettingsFab extends StatefulWidget {
  final List<Widget> children;
  final Color dividerColor;
  final Color iconColor;
  final VoidCallback generateArrayMethod;

  SettingsFab({
    Key? key,
    required this.children,
    required this.generateArrayMethod,
    dividerColor,
    this.iconColor = Colors.white,
  })  : dividerColor = dividerColor ?? Colors.white.withOpacity(0.8),
        super(key: key);

  @override
  _SettingsFabState createState() => _SettingsFabState();
}

class _SettingsFabState extends State<SettingsFab>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double openWidth = 260;
  double closeWidth = 40.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double size =
        closeWidth + (animationController.value * (openWidth - closeWidth));
    double borderRadius =
        8.0 + ((1 - animationController.value) * (48.0 - 8.0));
    Color? color =
        ColorTween(begin: backgroundHighlighter, end: primaryDarkColor)
            .animate(animationController)
            .value;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        color: color,
        child: isOpened ? _buildMenu() : _buildSettingsIcon(),
      ),
    );
  }

  Widget _buildMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Spacer(),
                ClickableIcon(
                  icon: Icons.close,
                  onPressed: _onTapSettings,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
            color: widget.dividerColor,
          ),
          Expanded(
            child: Scrollbar(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                children: widget.children,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FluentButton(
                  text: 'Generate',
                  backgroundColor: skyBlue,
                  onPressed: () {
                    widget.generateArrayMethod();
                    _onTapSettings();
                  },
                ),
                FluentButton(
                  text: 'Done',
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  onPressed: _onTapSettings,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSettingsIcon() {
    return Opacity(
      opacity: 1.0 - animationController.value,
      child: ClickableIcon(
        icon: Icons.settings,
        onPressed: _onTapSettings,
      ),
    );
  }

  bool get isOpened => animationController.status == AnimationStatus.completed;

  void _onTapSettings() {
    setState(() {
      if (isOpened)
        animationController.reverse();
      else
        animationController.forward();
    });
  }
}
