import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualize_data_structures/core/widgets/fluent_button.dart';
import 'package:visualize_data_structures/core/widgets/setting_slider_view.dart';

import 'bubble_sort_provider.dart';

class BubbleSortSettingsView extends StatefulWidget {
  @override
  _BubbleSortSettingsViewState createState() => _BubbleSortSettingsViewState();
}

class _BubbleSortSettingsViewState extends State<BubbleSortSettingsView> {
  BubbleSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BubbleSortProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Selector<BubbleSortProvider, int>(
          selector: (_, provider) => provider.maxArrayValue,
          builder: (_, int max, __) {
            return SettingSliderView(
              title: 'Max Array value = ${provider.maxArrayValue}',
              value: provider.maxArrayValue.toDouble(),
              min: provider.initialMinArrayValue.toDouble(),
              max: provider.initialMaxArrayValue.toDouble(),
              divisions: provider.initialMaxArrayValue,
              onChanged: (value) => provider.updateMaxArrayValue(value.toInt()),
            );
          },
        ),
        SizedBox(height: 12.0),
        Selector<BubbleSortProvider, double>(
          selector: (_, __) => provider.arraySize,
          builder: (_, double value, __) {
            return SettingSliderView(
              title: 'Max Array size = ${provider.arraySize}',
              value: provider.arraySize,
              min: provider.minArraySize,
              divisions: provider.maxArraySize,
              max: provider.maxArraySize.toDouble(),
              onChanged: provider.updateArraySize,
            );
          },
        ),
        SizedBox(height: 12.0),
        FluentButton(
          text: 'Generate',
          onPressed: provider.generateArray,
        ),
      ],
    );
  }
}
