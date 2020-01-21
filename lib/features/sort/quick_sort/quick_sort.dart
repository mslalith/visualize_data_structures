import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/constants/app_constants.dart';
import 'package:visualize_data_structures/core/providers/confetti_provider.dart';
import 'package:visualize_data_structures/core/providers/input_controls_provider.dart';
import 'package:visualize_data_structures/core/utils/app_utils.dart';
import 'package:visualize_data_structures/core/widgets/complexity_widget.dart';
import 'package:visualize_data_structures/core/widgets/header_bar.dart';
import 'package:visualize_data_structures/core/widgets/settings_fab.dart';

import 'quick_sort_bottom_bar.dart';
import 'quick_sort_data_view.dart';
import 'quick_sort_provider.dart';
import 'quick_sort_visualizer.dart';

class QuickSort extends StatefulWidget {
  static const String KEY = 'sort_quick_sort';

  @override
  _QuickSortState createState() => _QuickSortState();
}

class _QuickSortState extends State<QuickSort> {
  QuickSortProvider provider;

  @override
  void initState() {
    super.initState();
    Provider.of<QuickSortProvider>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<QuickSortProvider>(context);
    InputControlsProvider inputControlsProvider =
        Provider.of<InputControlsProvider>(context);
    RawKeyEvent keyEvent = inputControlsProvider.keyEvent;
    if (keyEvent != null && inputControlsProvider.isCurrentKeyUp) {
      LogicalKeyboardKey key = keyEvent.data.logicalKey;
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
                'The array is sorted.',
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
          return _QuickSortMobile();

        return _QuickSort();
      },
    );
  }
}

class _QuickSortMobile extends StatefulWidget {
  @override
  _QuickSortMobileState createState() => _QuickSortMobileState();
}

class _QuickSortMobileState extends State<_QuickSortMobile> {
  QuickSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<QuickSortProvider>(context);
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
              HeaderBar(title: 'Quick Sort'),
              SizedBox(height: 12.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    QuickSortVisualizer(),
                    SizedBox(height: 12.0),
                    QuickSortDataView(),
                    // Divider
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.grey,
                      ),
                    ),
                    QuickSortBottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
        _QuickSortSettingsFab(provider: provider),
      ],
    );
  }
}

class _QuickSortSettingsFab extends StatelessWidget {
  const _QuickSortSettingsFab({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final QuickSortProvider provider;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12.0,
      bottom: 12.0,
      child: SettingsFab(
        generateArrayMethod: provider.generateArray,
        children: <Widget>[
          SizedBox(height: 8.0),
          Selector<QuickSortProvider, int>(
            selector: (_, provider) => provider.maxArrayValue,
            builder: (_, int max, __) {
              return Text(
                "Max Array value = ${provider.maxArrayValue}",
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Selector<QuickSortProvider, int>(
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
          Selector<QuickSortProvider, double>(
            selector: (_, __) => provider.arraySize,
            builder: (_, double value, __) {
              return Text(
                "Max Array size = ${provider.arraySize}",
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Selector<QuickSortProvider, double>(
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
        ],
      ),
    );
  }
}

class _QuickSort extends StatelessWidget {
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
              HeaderBar(title: 'Quick Sort'),
              SizedBox(height: 12.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    QuickSortVisualizer(),
                    SizedBox(height: 12.0),
                    QuickSortDataView(),
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
              QuickSortBottomBar(),
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
              worstTime: 'O(n\u00B2)',
              averageTime: 'O(n logn)',
              bestTime: 'O(n logn)',
              space: 'O(n)',
            ),
          ),
        ),
      ],
    );
  }
}
