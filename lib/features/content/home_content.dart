import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visualize_data_structures/core/constants/app_constants.dart';
import 'package:visualize_data_structures/core/providers/confetti_provider.dart';
import 'package:visualize_data_structures/core/providers/topic_provider.dart';
import 'package:visualize_data_structures/core/utils/app_utils.dart';
import 'package:visualize_data_structures/core/widgets/cross_fade.dart';
import 'package:visualize_data_structures/core/widgets/input_controls.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with AfterLayoutMixin {
  bool isFirstRun = false;

  @override
  void afterFirstLayout(BuildContext context) async {
    Provider.of<ConfettiProvider>(context, listen: false).initialize(context);
    Provider.of<TopicProvider>(context, listen: false).initialize();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    isFirstRun = preferences.getBool(AppConstants.isFirstRun) ?? true;
    if (isFirstRun) {
      AppUtils.closeAnyDialogIfVisible(context);
      // if (!AppUtils.isMobile) AppUtils.showUsageDialog(context);
      await preferences.setBool(AppConstants.isFirstRun, false);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<TopicProvider>(
        builder: (_, TopicProvider provider, __) {
          if (provider.currentWidget == null)
            return Center(
              child: Text(
                provider.currentTopic,
                style: TextStyle(color: Colors.white),
              ),
            );

          return InputControls(
            child: CrossFade<Widget>(
              initialData: provider.currentWidget!,
              data: provider.currentWidget!,
              builder: (Widget child) => child,
            ),
          );
        },
      ),
    );
  }
}
