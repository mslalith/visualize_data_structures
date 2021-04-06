import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/node_widget.dart';
import 'package:visualize_data_structures/features/search/binary_search/binary_search_provider.dart';

class BinarySearchVisualizer extends StatefulWidget {
  @override
  _BinarySearchVisualizerState createState() => _BinarySearchVisualizerState();
}

class _BinarySearchVisualizerState extends State<BinarySearchVisualizer> {
  late BinarySearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BinarySearchProvider>(context);
    return Center(
      child: Selector<BinarySearchProvider, List<int>>(
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
          data: _getLowHighMidText(index),
        ),
      ],
    );
  }

  String _getLowHighMidText(index) {
    if (provider.low == index &&
        provider.mid == index &&
        provider.high == index) return 'lmh';

    if (provider.low == index && provider.high == index) return 'l h';

    if (provider.low == index && provider.mid == index) return 'l m';

    if (provider.mid == index && provider.high == index) return 'm h';

    if (provider.mid == index) return 'm';

    if (provider.low == index) return 'l';

    if (provider.high == index) return 'h';

    return '';
  }
}
