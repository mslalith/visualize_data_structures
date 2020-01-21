import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/constants/app_constants.dart';
import 'package:visualize_data_structures/core/providers/confetti_provider.dart';
import 'package:visualize_data_structures/core/providers/input_controls_provider.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/utils/app_utils.dart';
import 'package:visualize_data_structures/core/widgets/complexity_widget.dart';
import 'package:visualize_data_structures/core/widgets/header_bar.dart';
import 'package:visualize_data_structures/core/widgets/settings_fab.dart';

import 'linear_search_bottom_bar.dart';
import 'linear_search_data_view.dart';
import 'linear_search_provider.dart';
import 'linear_search_visualizer.dart';

class LinearSearch extends StatefulWidget {
  static const String KEY = 'search_linear_search';

  @override
  _LinearSearchState createState() => _LinearSearchState();
}

class _LinearSearchState extends State<LinearSearch> {
  LinearSearchProvider provider;

  @override
  void initState() {
    super.initState();
    Provider.of<LinearSearchProvider>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LinearSearchProvider>(context);
    InputControlsProvider inputControlsProvider =
        Provider.of<InputControlsProvider>(context);
    RawKeyEvent keyEvent = inputControlsProvider.keyEvent;
    if (keyEvent != null &&
        keyEvent.runtimeType.toString() == InputControlsProvider.KEY_EVENT_UP) {
      LogicalKeyboardKey key = keyEvent.data.logicalKey;
      print('TTT key = $key |');
      if (key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.arrowRight)
        provider.stepForward();
      else if (key == LogicalKeyboardKey.arrowLeft) provider.stepBack();
      inputControlsProvider.updateKeyEvent(null);
    }

    if (AppConstants.playConfetti) {
      if (provider.isCompleted && !AppUtils.isAnyDialogShowing) {
        AppUtils.isAnyDialogShowing = true;
        Future.delayed(
          Duration.zero,
          () async {
            Provider.of<ConfettiProvider>(context, listen: false)
                .playConfetti();
            bool retry = await AppUtils.showCompletionDialog(
              context,
              [
                'You found the element at index ${provider.iIndex}.',
                'If you didn\'t understood, you can always try again.',
              ],
            );
            if (retry) provider.generateArray();
          },
        );
      }
    }

    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        double height = MediaQuery.of(context).size.height;
        if (sizingInfo.isMobile || height < AppConstants.heightThreshold)
          return _LinearSearchMobile();

        return _LinearSearch();
      },
    );
  }
}

class _LinearSearchMobile extends StatefulWidget {
  @override
  __LinearSearchMobileState createState() => __LinearSearchMobileState();
}

class __LinearSearchMobileState extends State<_LinearSearchMobile> {
  LinearSearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LinearSearchProvider>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 12.0,
            left: 24.0,
            right: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeaderBar(title: 'Linear Search'),
              SizedBox(height: 12.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    LinearSearchVisualizer(),
                    SizedBox(height: 12.0),
                    LinearSearchDataView(),
                    // Divider
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.grey,
                      ),
                    ),
                    LinearSearchBottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
        _LinearSearchSettingsFab(provider: provider),
      ],
    );
  }
}

class _LinearSearchSettingsFab extends StatelessWidget {
  final LinearSearchProvider provider;

  const _LinearSearchSettingsFab({
    Key key,
    @required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12.0,
      bottom: 12.0,
      child: SettingsFab(
        generateArrayMethod: provider.generateArray,
        children: <Widget>[
          SizedBox(height: 8.0),
          Selector<LinearSearchProvider, int>(
            selector: (_, provider) => provider.maxArrayValue,
            builder: (_, int max, __) {
              return Text(
                "Max Array value = ${provider.maxArrayValue}",
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Selector<LinearSearchProvider, int>(
            selector: (_, provider) => provider.maxArrayValue,
            builder: (_, int max, __) {
              return SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(0.24),
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  value: provider.maxArrayValue.toDouble(),
                  min: provider.initialMinArrayValue.toDouble(),
                  max: provider.initialMaxArrayValue.toDouble(),
                  divisions: provider.initialMaxArrayValue,
                  onChanged: (value) =>
                      provider.updateMaxArrayValue(value.toInt()),
                ),
              );
            },
          ),
          SizedBox(height: 8.0),
          Selector<LinearSearchProvider, double>(
            selector: (_, __) => provider.arraySize,
            builder: (_, double value, __) {
              return Text(
                "Max Array size = ${provider.arraySize}",
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Selector<LinearSearchProvider, double>(
            selector: (_, __) => provider.arraySize,
            builder: (_, double value, __) {
              return SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(0.24),
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  value: provider.arraySize,
                  min: provider.minArraySize,
                  divisions: provider.maxArraySize,
                  max: provider.maxArraySize.toDouble(),
                  onChanged: provider.updateArraySize,
                ),
              );
            },
          ),
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
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class _LinearSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeaderBar(title: 'Linear Search'),
              SizedBox(height: 12.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    LinearSearchVisualizer(),
                    SizedBox(height: 12.0),
                    LinearSearchDataView(),
                  ],
                ),
              ),
              // Divider
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  thickness: 2.0,
                  color: Colors.grey,
                ),
              ),
              LinearSearchBottomBar(),
            ],
          ),
        ),
        Align(
          alignment: Alignment(1, -1),
          child: Container(
            padding: const EdgeInsets.only(
              top: 20.0,
              right: 16.0,
            ),
            child: ComplexityWidget(
              worstTime: 'O(n)',
              averageTime: 'O(n)',
              bestTime: 'O(1)',
              space: 'O(1)',
            ),
          ),
        ),
      ],
    );
  }
}
