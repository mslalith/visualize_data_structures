import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/fonts/fonts.dart';

import 'clickable_icon.dart';

class HeaderBar extends StatelessWidget {
  final String title;

  const HeaderBar({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        return Row(
          children: <Widget>[
            if (!sizingInfo.isDesktop)
              ClickableIcon(
                icon: Icons.menu,
                iconSize: 24.0,
                onPressed: () => _handleDrawer(context),
              ),
            SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline.copyWith(
                      fontFamily: Fonts.gelasio,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleDrawer(context) {
    ScaffoldState state = Scaffold.of(context);
    if (!state.isDrawerOpen) state.openDrawer();
  }
}
