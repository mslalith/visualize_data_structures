import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualize_data_structures/core/widgets/fluent_button.dart';
import 'package:visualize_data_structures/core/widgets/setting_slider_view.dart';

import 'insertion_sort_provider.dart';

class InsertionSortSettingsView extends StatefulWidget {
  @override
  _InsertionSortSettingsViewState createState() => _InsertionSortSettingsViewState();
}

class _InsertionSortSettingsViewState extends State<InsertionSortSettingsView> {
  InsertionSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<InsertionSortProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Selector<InsertionSortProvider, int>(
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
        Selector<InsertionSortProvider, double>(
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
