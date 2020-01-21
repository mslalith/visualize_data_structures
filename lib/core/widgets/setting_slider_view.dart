import 'package:flutter/material.dart';

import 'info_edit_widget.dart';

class SettingSliderView extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Function(double) onChanged;
  final Color backgroundColor;

  const SettingSliderView({
    Key key,
    @required this.title,
    @required this.value,
    @required this.min,
    @required this.max,
    @required this.divisions,
    @required this.onChanged,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoEditWidget(
      color: backgroundColor,
      icon: Icons.edit,
      infoChild: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      editChild: SliderTheme(
        data: SliderThemeData(
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white.withOpacity(0.24),
          thumbColor: Colors.white,
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
