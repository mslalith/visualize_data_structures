import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/node_widget.dart';
import 'package:visualize_data_structures/features/sort/insertion_sort/insertion_sort_provider.dart';

class InsertionSortVisualizer extends StatefulWidget {
  @override
  _InsertionSortVisualizerState createState() =>
      _InsertionSortVisualizerState();
}

class _InsertionSortVisualizerState extends State<InsertionSortVisualizer>
    with TickerProviderStateMixin {
  late InsertionSortProvider provider;
  double nodeSize = 30.0;
  late AnimationController keyAnimationController;

  @override
  void initState() {
    super.initState();
    keyAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          provider.isSwapping = false;
          provider.stepForward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<InsertionSortProvider>(context);
    return Center(
      child: Selector<InsertionSortProvider, List<int>>(
        selector: (_, provider) => provider.array,
        builder: (_, list, __) => _buildArrayNodes(),
      ),
    );
  }

  Widget _buildArrayNodes() {
    bool shouldLiftKey = provider.isLiftKeyState &&
        !provider.isSwapping &&
        !provider.isCompleted;

    bool shouldSwapKey = provider.isSwapKeyState &&
        !provider.isSwapping &&
        !provider.isCompleted;

    if (shouldLiftKey || shouldSwapKey) {
      provider.isSwapping = true;
      if (shouldLiftKey)
        keyAnimationController.forward();
      else if (shouldSwapKey) keyAnimationController.reverse();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        !provider.isNextState && !provider.isNoneState
            ? _buildAnimatedNodesWithKey()
            : _buildNodes(),
        _buildIndexes(),
        _buildIJ(),
      ],
    );
  }

  Widget _buildNodes() {
    List<int> list = provider.array;
    List<Widget> children = [];
    for (int i = 0; i < list.length; i++) {
      children.add(
        Positioned(
          left: i * (nodeSize + 1),
          top: nodeSize * 2,
          child: NodeWidget<int>(
            data: list[i],
            color: skyBlue,
          ),
        ),
      );
    }
    return Container(
      width: nodeSize * list.length + list.length,
      height: nodeSize * 3,
      child: Stack(
        children: children,
      ),
    );
  }

  double _getKeyLeft() {
    double defaultValue = provider.iIndex * (nodeSize + 1);
    if (provider.isSwapKeyState) {
      return Tween<double>(
        begin: provider.emptyIndex * (nodeSize + 1),
        end: defaultValue,
      )
          .animate(CurvedAnimation(
            parent: keyAnimationController,
            curve: Interval(0.5, 1.0),
          ))
          .value;
    }
    return defaultValue;
  }

  double _getKeyTop() {
    double defaultValue = nodeSize * 2;
    if (provider.isSwapKeyState) {
      return Tween<double>(
        begin: defaultValue,
        end: 0.0,
      )
          .animate(CurvedAnimation(
            parent: keyAnimationController,
            curve: Interval(0.0, 0.5),
          ))
          .value;
    } else if (!provider.isNoneState || !provider.isNextState)
      return defaultValue * (1 - keyAnimationController.value);

    return defaultValue;
  }

  Widget _buildAnimatedNodesWithKey() {
    List<int> list = provider.array;

    if (provider.isLiftKeyState) {
      list = provider.oldArray;
    } else {
      list = provider.array;
    }

    List<Widget> children = [];
    for (int i = 0; i < list.length; i++) {
      children.add(
        Positioned(
          top: nodeSize * 2,
          left: i * (nodeSize + 1),
          child: NodeWidget<String>(
            data: provider.emptyIndex == i ? '' : list[i].toString(),
            color: provider.emptyIndex == i ? Colors.transparent : skyBlue,
          ),
        ),
      );
    }

    children.add(Positioned(
      left: _getKeyLeft(),
      top: _getKeyTop(),
      child: NodeWidget<int>(
        data: provider.key,
        color: skyBlue,
      ),
    ));

    return Container(
      width: nodeSize * list.length + list.length,
      height: nodeSize * 3,
      child: Stack(
        children: children,
      ),
    );
  }

  Widget _buildIndexes() {
    int size = provider.array.length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < size; i++) NodeWidget<int>(data: i)
      ],
    );
  }

  Widget _buildIJ() {
    int size = provider.array.length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < size; i++) NodeWidget<String>(data: _getIJText(i))
      ],
    );
  }

  String _getIJText(index) {
    if (provider.iIndex == index) return 'i';
    if (provider.jIndex == index) return 'j';
    return '';
  }
}
