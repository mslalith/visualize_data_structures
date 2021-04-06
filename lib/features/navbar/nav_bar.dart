import 'package:flutter/material.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/widgets/made_using_flutter.dart';
import 'package:visualize_data_structures/features/navbar/brand_info.dart';
import 'package:visualize_data_structures/features/navbar/nav_list.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(
        right: Radius.circular(16.0),
      ),
      child: Container(
        width: 210.0,
        color: primaryDarkColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 6.0),
            BrandInfo(),
            SizedBox(height: 6.0),
            Expanded(child: NavList()),
            SizedBox(height: 6.0),
            MadeUsingFlutter(),
            SizedBox(height: 6.0),
          ],
        ),
      ),
    );
  }
}
