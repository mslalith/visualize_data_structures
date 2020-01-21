import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/fonts/fonts.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/clickable_icon.dart';
import 'package:visualize_data_structures/core/widgets/node_widget.dart';

import 'binary_search_provider.dart';

class BinarySearchDataView extends StatefulWidget {
  @override
  _BinarySearchDataViewState createState() => _BinarySearchDataViewState();
}

class _BinarySearchDataViewState extends State<BinarySearchDataView> {
  BinarySearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BinarySearchProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDetailView(sizingInfo.isMobile),
            SizedBox(height: 16.0),
            Consumer<BinarySearchProvider>(
              builder: (_, __, ___) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildText('array\t=\t${provider.array}'),
                    _buildText('l\t=\t${provider.low}'),
                    _buildText('m\t=\t${provider.mid}'),
                    _buildText('h\t=\t${provider.high}'),
                    _buildText('array[m]\t=\t${provider.currentValue}'),
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
      width: provider.state == BinarySearchState.selectInterval ? 300.0 : null,
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

  Widget _buildNode(int value, int index) {
    return Column(
      children: <Widget>[
        NodeWidget<int>(
          data: value,
          color: skyBlue,
        ),
        NodeWidget<String>(
          data: '$index',
        ),
      ],
    );
  }

  Widget _buildDetailPicture() {
    if (provider.state == BinarySearchState.findMid) {
      List<int> list = provider.arrayInterval;
      return Wrap(
        children: <Widget>[
          for (int i = 0; i < list.length; i++)
            _buildNode(list[i], provider.low + i),
        ],
      );
    } else if (provider.state == BinarySearchState.selectInterval) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (provider.isLeftInterval)
            Icon(
              FontAwesomeIcons.handPointLeft,
              color: Colors.blue,
              size: 24.0,
            ),
          if (provider.isLeftInterval) SizedBox(width: 16.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NodeWidget<int>(
                data: provider.currentValue,
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
            provider.isLeftInterval
                ? '>'
                : provider.isRightInterval ? '<' : '=',
            style: Theme.of(context).textTheme.headline,
          ),
          SizedBox(width: 16.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NodeWidget<int>(
                data: provider.searchValue,
                color: skyBlue,
              ),
              SizedBox(height: 16.0),
              Text(
                'array[s]',
                style: TextStyle(fontFamily: Fonts.courierPrime),
              )
            ],
          ),
          SizedBox(width: 16.0),
          _getDetailIcon(),
        ],
      );
    }
    return Container();
  }

  Widget _getDetailText() {
    if (provider.state == BinarySearchState.findMid) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'm = l + (h - l) / 2',
          style: TextStyle(
            fontFamily: Fonts.courierPrime,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: '\n\nfind mid for the interval using above formula',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }
    String text = '';
    if (provider.currentValue == provider.searchValue)
      text =
          'found the value at index ${provider.mid}, so we return ${provider.mid}';
    else {
      if (provider.state == BinarySearchState.findMid)
        text = '''m = l + (h - l) / 2

find mid for the interval using above formula''';
      else if (provider.state == BinarySearchState.selectInterval) {
        if (provider.isLeftInterval)
          text =
              '${provider.searchValue} is in left half of the interval, so select left interval by changing `h` to `m - 1`';
        else if (provider.isRightInterval)
          text =
              '${provider.searchValue} is in right half of the interval, so select right interval by changing `l` to `m + 1`';
      }
    }
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }

  Widget _getDetailIcon() {
    IconData iconData;
    if (provider.isRightInterval)
      iconData = FontAwesomeIcons.handPointRight;
    else if (provider.currentValue == provider.searchValue)
      iconData = FontAwesomeIcons.checkCircle;

    return Icon(
      iconData,
      color: provider.currentValue == provider.searchValue
          ? Colors.green
          : Colors.blue,
      size: 24.0,
    );
  }
}
