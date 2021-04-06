import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/fonts/fonts.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/clickable_icon.dart';
import 'package:visualize_data_structures/core/widgets/node_widget.dart';
import 'package:visualize_data_structures/features/sort/selection_sort/selection_sort_provider.dart';

class SelectionSortDataView extends StatefulWidget {
  @override
  _SelectionSortDataViewState createState() => _SelectionSortDataViewState();
}

class _SelectionSortDataViewState extends State<SelectionSortDataView> {
  late SelectionSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SelectionSortProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDetailView(sizingInfo.isMobile),
            SizedBox(height: 16.0),
            Consumer<SelectionSortProvider>(
              builder: (_, __, ___) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildText('array\t=\t${provider.array}'),
                    _buildText('i\t=\t${provider.iIndex}'),
                    _buildText('j\t=\t${provider.jIndex}'),
                    _buildText('m (min)\t=\t${provider.minIndex}'),
                    _buildText('array[i]\t=\t${provider.iThValue}'),
                    _buildText('array[j]\t=\t${provider.jThValue}'),
                    _buildText('array[m]\t=\t${provider.minThValue}'),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NodeWidget<int>(
              data: provider.minThValue,
              color: skyBlue,
            ),
            SizedBox(height: 16.0),
            Text(
              'array[m]',
              style: TextStyle(fontFamily: Fonts.courierPrime),
            )
          ],
        ),
        SizedBox(width: 16.0),
        Text(
          provider.isJMin ? '>' : '<',
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(width: 16.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NodeWidget<int>(
              data: provider.jThValue,
              color: skyBlue,
            ),
            SizedBox(height: 16.0),
            Text(
              'array[j]',
              style: TextStyle(fontFamily: Fonts.courierPrime),
            )
          ],
        ),
      ],
    );
  }

  Widget _getDetailText() {
    String text = provider.isJMin
        ? '`j` value is less than `m` value, so make `j` as `m` value and move on `j`'
        : 'as the `j` value is greater than `m`, we skip it';

    if (provider.isJLast) {
      text =
          'we found ${provider.minThValue} as smallest value, so we swap it with `i`';
      if (provider.iIndex == provider.minIndex)
        text = 'as the smallest value is in place, we skip it';
      if (provider.isJMin)
        text =
            'we found ${provider.jThValue} as smallest value, so we swap it with `i`';
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(height: 1.4),
    );
  }
}
