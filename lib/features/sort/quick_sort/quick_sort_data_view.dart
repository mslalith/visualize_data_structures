import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/fonts/fonts.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/clickable_icon.dart';
import 'package:visualize_data_structures/core/widgets/node_widget.dart';
import 'package:visualize_data_structures/features/sort/quick_sort/quick_sort_provider.dart';

class QuickSortDataView extends StatefulWidget {
  @override
  _QuickSortDataViewState createState() => _QuickSortDataViewState();
}

class _QuickSortDataViewState extends State<QuickSortDataView> {
  late QuickSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<QuickSortProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDetailView(sizingInfo.isMobile),
            SizedBox(height: 16.0),
            Consumer<QuickSortProvider>(
              builder: (_, __, ___) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildText('array\t=\t${provider.array}'),
                    if (provider.pivotIndex != -1)
                      _buildText('p (pivot)\t=\t${provider.pivotIndex}'),
                    _buildText('pivot value\t=\t${provider.pivotValue}'),
                    _buildText('l (left)\t=\t${provider.leftIndex}'),
                    _buildText('r (right)\t=\t${provider.rightIndex}'),
                    _buildText('i\t=\t${provider.iIndex}'),
                    _buildText('j\t=\t${provider.jIndex}'),
                    _buildText('array[l]\t=\t${provider.leftThValue}'),
                    _buildText('array[r]\t=\t${provider.rightThValue}'),
                    if (provider.iIndex >= 0 &&
                        provider.iIndex < provider.arraySize)
                      _buildText('array[i]\t=\t${provider.iThValue}'),
                    if (provider.jIndex! >= 0 &&
                        provider.jIndex! < provider.arraySize)
                      _buildText('array[j]\t=\t${provider.jThValue}'),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildText(text) {
    List<String> data = text.split('\t');
    return Container(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Text(
              data[0],
              textAlign: TextAlign.end,
              style: TextStyle(fontFamily: Fonts.courierPrime),
            ),
          ),
          SizedBox(width: 24.0),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              data[1],
              style: TextStyle(fontFamily: Fonts.courierPrime),
            ),
          ),
          SizedBox(width: 24.0),
          Expanded(
            child: Text(
              data[2],
              style: TextStyle(fontFamily: Fonts.courierPrime),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailView(bool isMobile) {
    Widget child = Container(
      width: isMobile ? null : 300.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: backgroundHighlighter,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildDetailPicture(),
          SizedBox(height: 16.0),
          _getDetailText(),
        ],
      ),
    );

    if (isMobile) child = Expanded(child: child);

    // Since RawKeyboardListener is not working properly in release mode.
    // The next and previous buttons are made visible.
    // Once the bug is fixed by the Flutter team, the below line will be removed.
    isMobile = true;

    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (isMobile && provider.canGoBack)
            ClickableIcon(
              icon: Icons.arrow_back,
              backgroundColor: skyBlue,
              onPressed: provider.stepBackAndNotify,
              isVisible: provider.canGoBack,
            ),
          SizedBox(width: 8.0),
          child,
          SizedBox(width: 8.0),
          if (isMobile && provider.canGoForward)
            ClickableIcon(
              icon: Icons.arrow_forward,
              backgroundColor: skyBlue,
              onPressed: provider.stepForwardAndNotify,
              isVisible: provider.canGoForward,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailPicture() {
    List<String> list = _getDetailPictureData();
    if (list.isEmpty) return Container();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NodeWidget<int>(
              data: int.parse(list[0]),
              color: skyBlue,
            ),
            SizedBox(height: 16.0),
            Text(
              list[1],
              style: TextStyle(fontFamily: Fonts.courierPrime),
            )
          ],
        ),
        SizedBox(width: 16.0),
        Text(
          list[2],
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(width: 16.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NodeWidget<int>(
              data: int.parse(list[3]),
              color: skyBlue,
            ),
            SizedBox(height: 16.0),
            Text(
              list[4],
              style: TextStyle(fontFamily: Fonts.courierPrime),
            )
          ],
        ),
      ],
    );
  }

  List<String> _getDetailPictureData() {
    List<String> list = [];
    if (provider.isCompleted)
      return list;
    else if (provider.isFindLeftMaxState) {
      int value = provider.iThValue;
      int pivot = provider.pivotValue;
      list.add(value.toString());
      list.add('array[i]');
      list.add(value > pivot ? '>' : '<=');
      list.add(pivot.toString());
      list.add('array[p]');
      return list;
    } else if (provider.isFindRightMinState) {
      int value = provider.jThValue;
      int pivot = provider.pivotValue;
      list.add(value.toString());
      list.add('array[j]');
      list.add(value > pivot ? '>' : '<=');
      list.add(pivot.toString());
      list.add('array[p]');
      return list;
    } else if (provider.isCompareState ||
        provider.isPartitionState ||
        provider.isSwapState) {
      int i = provider.iIndex;
      int j = provider.jIndex!;
      list.add(i.toString());
      list.add('i');
      list.add(i <= j ? '<=' : '>');
      list.add(j.toString());
      list.add('j');
      return list;
    }
    return list;
  }

  Widget _getDetailText() {
    String text = '';

    if (provider.isCompleted)
      text =
          'Well done the array is sorted. If you didn\'t understood give it a try again';
    else if (provider.isNoneState)
      text =
          'Assign the left and right indexes and initialize `i`, `j` values with left and right indexes';
    else if (provider.isFindLeftMaxState) {
      if (provider.iThValue < provider.pivotValue)
        text =
            '${provider.iThValue} is smaller than ${provider.pivotValue}. It should be and is in the left part of pivot, so increment `i`';
      else
        text =
            '${provider.iThValue} is greater than ${provider.pivotValue}. It should be in the right part of pivot, so we find the minimum value in the right part of pivot to swap them both';
    } else if (provider.isFindRightMinState) {
      if (provider.jThValue > provider.pivotValue)
        text =
            '${provider.jThValue} is greater than ${provider.pivotValue}. It should be and is in the right part of pivot, so we decrement `j`';
      else
        text =
            '${provider.jThValue} is smaller than ${provider.pivotValue}. It should be in the left part of pivot, so we compare it with `i`';
    } else if (provider.isCompareState || provider.isSwapState) {
      if (provider.iIndex <= provider.jIndex!)
        text =
            'since `i` index ${provider.iIndex} is less than ${provider.iIndex == provider.jIndex ? 'or equal to' : ''} `j` index ${provider.jIndex}, their values are in wrong positions, so we swap them';
      else
        text =
            'since `i` index ${provider.iIndex} is greater than `j` index ${provider.jIndex}, we skip them and move onto next';
    } else if (provider.isPartitionState) {
      if (provider.iIndex <= provider.jIndex!)
        text =
            'since `i` index ${provider.iIndex} is less than ${provider.iIndex == provider.jIndex ? 'or equal to' : ''} `j` index ${provider.jIndex}, we continue again to find the left maximum value and right minimum value.\nRemember that the value in `p` may change but pivot value will not change';
      else {
        text =
            'since `i` index ${provider.iIndex} is greater than `j` index ${provider.jIndex}';
        if (provider.leftIndex! < provider.iIndex - 1)
          text += ', we\'ll sort the left part of pivot';
        else if (provider.iIndex < provider.rightIndex!)
          text += ', we\'ll sort the right part of pivot';
      }
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(height: 1.4),
    );
  }
}
