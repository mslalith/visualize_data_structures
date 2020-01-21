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

import 'binary_search_bottom_bar.dart';
import 'binary_search_data_view.dart';
import 'binary_search_provider.dart';
import 'binary_search_visualizer.dart';

class BinarySearch extends StatefulWidget {
  static const String KEY = 'search_binary_search';

  @override
  _BinarySearchState createState() => _BinarySearchState();
}

class _BinarySearchState extends State<BinarySearch> {
  BinarySearchProvider provider;

  @override
  void initState() {
    super.initState();
    Provider.of<BinarySearchProvider>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BinarySearchProvider>(context);
    InputControlsProvider inputControlsProvider =
        Provider.of<InputControlsProvider>(context);
    RawKeyEvent keyEvent = inputControlsProvider.keyEvent;
    if (keyEvent != null &&
        keyEvent.runtimeType.toString() == InputControlsProvider.KEY_EVENT_UP) {
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
                'You found the element at index ${provider.mid}.',
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
          return _BinarySearchMobile();

        return _BinarySearch();
      },
    );
  }
}

class _BinarySearchMobile extends StatefulWidget {
  @override
  __BinarySearchMobileState createState() => __BinarySearchMobileState();
}

class __BinarySearchMobileState extends State<_BinarySearchMobile> {
  BinarySearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BinarySearchProvider>(context);
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
              HeaderBar(title: 'Binary Search'),
              SizedBox(height: 12.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    BinarySearchVisualizer(),
                    SizedBox(height: 12.0),
                    BinarySearchDataView(),
                    // Divider
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.grey,
                      ),
                    ),
                    BinarySearchBottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
        _BinarySearchSettingsFab(provider: provider),
      ],
    );
  }
}

class _BinarySearchSettingsFab extends StatelessWidget {
  const _BinarySearchSettingsFab({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final BinarySearchProvider provider;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12.0,
      bottom: 12.0,
      child: SettingsFab(
        generateArrayMethod: provider.generateArray,
        children: <Widget>[
          SizedBox(height: 8.0),
          Selector<BinarySearchProvider, int>(
            selector: (_, provider) => provider.maxArrayValue,
            builder: (_, int max, __) {
              return Text(
                "Max Array value = ${provider.maxArrayValue}",
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Selector<BinarySearchProvider, int>(
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
          Selector<BinarySearchProvider, double>(
            selector: (_, __) => provider.arraySize,
            builder: (_, double value, __) {
              return Text(
                "Max Array size = ${provider.arraySize}",
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Selector<BinarySearchProvider, double>(
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

class _BinarySearch extends StatelessWidget {
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
              HeaderBar(title: 'Binary Search'),
              SizedBox(height: 12.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    BinarySearchVisualizer(),
                    SizedBox(height: 12.0),
                    BinarySearchDataView(),
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
              BinarySearchBottomBar(),
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
              worstTime: 'O(log n)',
              averageTime: 'O(log n)',
              bestTime: 'O(1)',
              space: 'O(1)',
            ),
          ),
        ),
      ],
    );
  }
}
