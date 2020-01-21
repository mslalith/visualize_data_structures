import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';

class ToRemember extends StatefulWidget {
  final double width;
  final double height;
  final List<String> points;

  const ToRemember({
    Key key,
    this.width = 300.0,
    this.height = 210.0,
    @required this.points,
  }) : super(key: key);

  @override
  _ToRememberState createState() => _ToRememberState();
}

class _ToRememberState extends State<ToRemember> with AfterLayoutMixin {
  ScrollController scrollController;
  bool showFab;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() => setState(() {}));
  }

  @override
  void afterFirstLayout(BuildContext context) => setState(() {});

  @override
  Widget build(BuildContext context) {
    showFab = false;
    if (scrollController.hasClients)
      showFab = scrollController.position.maxScrollExtent != 0;

    return Card(
      color: importantColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 12.0,
                    bottom: 6.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 12.0,
                        height: 12.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 2.5,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'to Remember',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    controller: scrollController,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (String point in widget.points) _buildPoint(point)
                    ],
                  ),
                ),
              ],
            ),
            if (showFab) _buildFab(),
            if (!isBottom) _showFade(),
          ],
        ),
      ),
    );
  }

  bool get isBottom => scrollController.hasClients
      ? (scrollController.offset >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange)
      : false;

  Widget _buildFab() {
    return Positioned(
      right: 16.0,
      bottom: 16.0,
      child: RawMaterialButton(
        constraints: BoxConstraints.tightFor(
          width: 28.0,
          height: 28.0,
        ),
        shape: CircleBorder(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: primaryDarkColor,
        child: Icon(
          isBottom ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: Colors.white,
          size: 20.0,
        ),
        onPressed: _onFabPressed,
      ),
    );
  }

  void _onFabPressed() {
    scrollController.animateTo(
      isBottom ? 0.0 : scrollController.offset + 20.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _showFade() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      height: 16.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [importantColor.withOpacity(0.0), importantColor],
          ),
        ),
      ),
    );
  }

  Widget _buildPoint(String point) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.done,
            size: 16.0,
            color: Colors.white,
          ),
          SizedBox(width: 6.0),
          Flexible(
            child: Text(
              point,
              style: TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
