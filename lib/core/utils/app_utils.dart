import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/providers/confetti_provider.dart';
import 'package:visualize_data_structures/core/widgets/fluent_button.dart';
import 'package:visualize_data_structures/core/widgets/info_dialog.dart';

class AppUtils {
  static DeviceScreenType? screenType;
  static bool isMobile = screenType == DeviceScreenType.mobile;
  static bool isTablet = screenType == DeviceScreenType.tablet;
  static bool isDesktop = screenType == DeviceScreenType.desktop;

  static bool isAnyDialogShowing = false;

  static void closeAnyDialogIfVisible(BuildContext context) {
    if (isAnyDialogShowing) Navigator.pop(context);
  }

  static void showUsageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        isAnyDialogShowing = true;
        return InfoDialog(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _blackText('Press '),
                _boldText('Space '),
                _blackText('or '),
                Icon(Icons.arrow_forward, size: 18),
                _blackText(' to goto next step'),
              ],
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _blackText('Press '),
                Icon(Icons.arrow_back, size: 18),
                _blackText(' to goto previous step'),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showCompletionDialog(
      BuildContext context, List<String> texts) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        isAnyDialogShowing = true;
        return InfoDialog(
          titleText: 'Congratulations !!!',
          children: <Widget>[
            for (String text in texts)
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  height: 1.6,
                ),
              ),
          ],
          actions: <Widget>[
            FluentButton(
              text: 'Go Again',
              onPressed: () {
                isAnyDialogShowing = false;
                Navigator.pop(context, true);
                Provider.of<ConfettiProvider>(context, listen: false)
                    .stopConfetti();
              },
            ),
            SizedBox(width: 8.0),
            FluentButton(
              text: 'Done',
              backgroundColor: Colors.transparent,
              textColor: Colors.black,
              onPressed: () {
                isAnyDialogShowing = false;
                Navigator.pop(context, false);
                Provider.of<ConfettiProvider>(context, listen: false)
                    .stopConfetti();
              },
            ),
          ],
        );
      },
    );
  }

  static Text _blackText(text) => Text(
        text,
        style: TextStyle(color: Colors.black),
      );

  static Text _boldText(text) => Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
}
