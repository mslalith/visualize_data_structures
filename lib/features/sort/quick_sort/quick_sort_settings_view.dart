import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualize_data_structures/core/widgets/fluent_button.dart';
import 'package:visualize_data_structures/core/widgets/setting_slider_view.dart';
import 'package:visualize_data_structures/features/sort/quick_sort/quick_sort_provider.dart';

class QuickSortSettingsView extends StatefulWidget {
  @override
  _QuickSortSettingsViewState createState() => _QuickSortSettingsViewState();
}

class _QuickSortSettingsViewState extends State<QuickSortSettingsView> {
  late QuickSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<QuickSortProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Selector<QuickSortProvider, int>(
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
        Selector<QuickSortProvider, double>(
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
