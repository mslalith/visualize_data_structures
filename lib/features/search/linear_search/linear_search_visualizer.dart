import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/node_widget.dart';
import 'package:visualize_data_structures/features/search/linear_search/linear_search_provider.dart';

class LinearSearchVisualizer extends StatefulWidget {
  @override
  _LinearSearchVisualizerState createState() => _LinearSearchVisualizerState();
}

class _LinearSearchVisualizerState extends State<LinearSearchVisualizer> {
  late LinearSearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LinearSearchProvider>(context);
    return Center(
      child: Selector<LinearSearchProvider, List<int>>(
        selector: (_, provider) => provider.array,
        builder: (_, list, __) => _buildArrayNodes(list),
      ),
    );
  }

  Widget _buildArrayNodes(List<int> list) {
    return Wrap(
      children: <Widget>[
        for (int i = 0; i < list.length; i++) _buildNode(list[i], i)
      ],
    );
  }

  Widget _buildNode(int value, int index) {
    return Column(
      children: <Widget>[
        NodeWidget<String>(
          data: provider.searchIndex == index ? 's' : '',
        ),
        NodeWidget<int>(
          data: value,
          color: skyBlue,
        ),
        NodeWidget<String>(
          data: '$index',
        ),
        NodeWidget<String>(
          data: provider.iIndex == index ? 'i' : '',
        ),
      ],
    );
  }
}
