import 'package:flutter/material.dart';
import 'package:visualize_data_structures/core/fonts/fonts.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';

class BrandInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryDarkColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 18.0,
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Icon(Icons.dashboard),
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _fontText(context, 'Visualize'),
              _fontText(context, 'Data Structures'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fontText(context, text) => Text(
        text,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontFamily: Fonts.gelasio,
              letterSpacing: 0.8,
            ),
      );
}
