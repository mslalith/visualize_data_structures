import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/utils/app_utils.dart';

class InfoDialog extends StatelessWidget {
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final List<Widget> children;
  final List<Widget> actions;
  final String titleText;

  InfoDialog({
    Key key,
    borderRadius,
    padding,
    this.titleText,
    this.actions = const [],
    @required this.children,
  })  : borderRadius = BorderRadius.circular(12.0),
        padding = const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      contentPadding: EdgeInsets.zero,
      children: <Widget>[
        if (titleText != null)
          Container(
            padding: EdgeInsets.only(top: padding.top),
            child: Center(
              child: Text(
                titleText,
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        Container(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
        if (actions.isEmpty)
          Container(
            width: double.infinity,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: skyBlue,
              textColor: Colors.white,
              child: Text('OK'),
              onPressed: () {
                AppUtils.isAnyDialogShowing = false;
                Navigator.pop(context);
              },
            ),
          ),
        if (actions.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          )
      ],
    );
  }
}
