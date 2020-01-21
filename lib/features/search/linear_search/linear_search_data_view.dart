import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visualize_data_structures/core/fonts/fonts.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/clickable_icon.dart';
import 'package:visualize_data_structures/core/widgets/node_widget.dart';

import 'linear_search_provider.dart';

class LinearSearchDataView extends StatefulWidget {
  @override
  _LinearSearchDataViewState createState() => _LinearSearchDataViewState();
}

class _LinearSearchDataViewState extends State<LinearSearchDataView> {
  LinearSearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LinearSearchProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDetailView(sizingInfo.isMobile),
            SizedBox(height: 16.0),
            Consumer<LinearSearchProvider>(
              builder: (_, __, ___) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildText('array\t=\t${provider.array}'),
                    _buildText('i\t=\t${provider.iIndex}'),
                    _buildText('array[i]\t=\t${provider.currentValue}'),
                    _buildText('s\t=\t${provider.searchIndex}'),
                    _buildText('to find\t=\t${provider.searchValue}'),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NodeWidget<int>(
                data: provider.currentValue,
                color: skyBlue,
              ),
              SizedBox(width: 16.0),
              Text(
                '=',
                style: Theme.of(context).textTheme.headline,
              ),
              SizedBox(width: 16.0),
              NodeWidget<int>(
                data: provider.searchValue,
                color: skyBlue,
              ),
              SizedBox(width: 16.0),
              Icon(
                provider.currentValue == provider.searchValue
                    ? FontAwesomeIcons.checkCircle
                    : FontAwesomeIcons.timesCircle,
                color: provider.currentValue == provider.searchValue
                    ? Colors.green
                    : Colors.red,
                size: 24.0,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            provider.currentValue == provider.searchValue
                ? 'found the value at index ${provider.iIndex}, so we return ${provider.iIndex}'
                : provider.iIndex < provider.arraySize
                ? 'so we move onto next value'
                : 'value not found in the array so we return -1',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (isMobile)
      child = Expanded(child: child);

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
}
