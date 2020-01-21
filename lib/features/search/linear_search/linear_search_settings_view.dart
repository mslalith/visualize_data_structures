import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/fluent_button.dart';
import 'package:visualize_data_structures/core/widgets/setting_slider_view.dart';

import 'linear_search_provider.dart';

class LinearSearchSettingsView extends StatefulWidget {
  @override
  _LinearSearchSettingsViewState createState() => _LinearSearchSettingsViewState();
}

class _LinearSearchSettingsViewState extends State<LinearSearchSettingsView> {
  LinearSearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LinearSearchProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Selector<LinearSearchProvider, int>(
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
        Selector<LinearSearchProvider, double>(
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
        Selector<LinearSearchProvider, bool>(
          selector: (_, pro) => pro.isUnique,
          builder: (_, bool isUnique, __) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.white70,
                  ),
                  child: Checkbox(
                    value: isUnique,
                    checkColor: primaryDarkColor,
                    onChanged: provider.setIsUnique,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                InkWell(
                  onTap: () => provider.setIsUnique(!provider.isUnique),
                  child: Text('Unique values'),
                ),
              ],
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
