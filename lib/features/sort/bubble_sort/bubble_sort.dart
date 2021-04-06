import 'dart:math' show pi;

import 'package:confetti/confetti.dart';
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
import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort_bottom_bar.dart';
import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort_data_view.dart';
import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort_provider.dart';
import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort_visualizer.dart';

class BubbleSort extends StatefulWidget {
  static const String KEY = 'sort_bubble_sort';

  @override
  _BubbleSortState createState() => _BubbleSortState();
}

class _BubbleSortState extends State<BubbleSort> {
  late BubbleSortProvider provider;
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    Provider.of<BubbleSortProvider>(context, listen: false).initialize();
    confettiController = ConfettiController(duration: Duration(seconds: 6));
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BubbleSortProvider>(context);
    InputControlsProvider inputControlsProvider =
        Provider.of<InputControlsProvider>(context);
    RawKeyEvent? keyEvent = inputControlsProvider.keyEvent;
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
            final bool? retry = await AppUtils.showCompletionDialog(
              context,
              [
                'The array is sorted.',
                'If you didn\'t understood, you can always try again.',
              ],
            );
            if (retry != null && retry) provider.generateArray();
          },
        );
      }
    }

    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        double height = MediaQuery.of(context).size.height;
        if (sizingInfo.isMobile || height < AppConstants.heightThreshold)
          return _BubbleSortMobile(confettiController: confettiController);

        return _BubbleSort(confettiController: confettiController);
      },
    );
  }
}

class _BubbleSortMobile extends StatefulWidget {
  final ConfettiController confettiController;

  _BubbleSortMobile({
    Key? key,
    required this.confettiController,
  }) : super(key: key);

  @override
  _BubbleSortMobileState createState() => _BubbleSortMobileState();
}

class _BubbleSortMobileState extends State<_BubbleSortMobile> {
  late BubbleSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BubbleSortProvider>(context);
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
              HeaderBar(title: 'Bubble Sort'),
              SizedBox(height: 12.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    BubbleSortVisualizer(),
                    SizedBox(height: 12.0),
                    BubbleSortDataView(),
                    // Divider
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.grey,
                      ),
                    ),
                    BubbleSortBottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
        _BubbleSortSettingsFab(provider: provider),
        Align(
          alignment: Alignment(1, -0.65),
          child: ConfettiWidget(
            confettiController: widget.confettiController,
            blastDirection: 170 * (-pi / 180),
            emissionFrequency: 0.1,
            numberOfParticles: 4,
            minBlastForce: 42,
            maxBlastForce: 58,
            minimumSize: Size(8, 4),
            maximumSize: Size(14, 7),
          ),
        ),
      ],
    );
  }
}

class _BubbleSortSettingsFab extends StatelessWidget {
  const _BubbleSortSettingsFab({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final BubbleSortProvider provider;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12.0,
      bottom: 12.0,
      child: SettingsFab(
        generateArrayMethod: provider.generateArray,
        children: <Widget>[
          SizedBox(height: 8.0),
          Selector<BubbleSortProvider, int>(
            selector: (_, provider) => provider.maxArrayValue,
            builder: (_, int max, __) {
              return Text(
                "Max Array value = ${provider.maxArrayValue}",
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Selector<BubbleSortProvider, int>(
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
          Selector<BubbleSortProvider, double>(
            selector: (_, __) => provider.arraySize,
            builder: (_, double value, __) {
              return Text(
                "Max Array size = ${provider.arraySize}",
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Selector<BubbleSortProvider, double>(
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

class _BubbleSort extends StatelessWidget {
  final ConfettiController confettiController;

  const _BubbleSort({
    Key? key,
    required this.confettiController,
  }) : super(key: key);

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
              HeaderBar(title: 'Bubble Sort'),
              SizedBox(height: 12.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    BubbleSortVisualizer(),
                    SizedBox(height: 12.0),
                    BubbleSortDataView(),
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
              BubbleSortBottomBar(),
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
              averageTime: 'O(n\u00B2)',
              bestTime: 'O(n)',
              space: 'O(1)',
            ),
          ),
        ),
        Align(
          alignment: Alignment(1, -0.65),
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirection: 170 * (-pi / 180),
            emissionFrequency: 0.1,
            numberOfParticles: 4,
            minBlastForce: 42,
            maxBlastForce: 58,
            minimumSize: Size(8, 4),
            maximumSize: Size(14, 7),
          ),
        ),
      ],
    );
  }
}
