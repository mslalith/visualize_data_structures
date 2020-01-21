import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/fonts/fonts.dart';
import 'package:visualize_data_structures/core/providers/confetti_provider.dart';
import 'package:visualize_data_structures/core/providers/input_controls_provider.dart';
import 'package:visualize_data_structures/core/providers/topic_provider.dart';
import 'package:visualize_data_structures/core/themes/themes.dart';
import 'package:visualize_data_structures/core/utils/app_utils.dart';
import 'package:visualize_data_structures/features/content/home_content.dart';
import 'package:visualize_data_structures/features/navbar/nav_bar.dart';
import 'package:visualize_data_structures/features/search/binary_search/binary_search_provider.dart';
import 'package:visualize_data_structures/features/search/linear_search/linear_search_provider.dart';
import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort_provider.dart';
import 'package:visualize_data_structures/features/sort/insertion_sort/insertion_sort_provider.dart';
import 'package:visualize_data_structures/features/sort/quick_sort/quick_sort_provider.dart';
import 'package:visualize_data_structures/features/sort/selection_sort/selection_sort_provider.dart';

void main() => runApp(VisualizeDSApp());

class VisualizeDSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfettiProvider()),
        ChangeNotifierProvider(create: (_) => InputControlsProvider()),
        ChangeNotifierProvider(create: (_) => TopicProvider()),
        ChangeNotifierProvider(create: (_) => LinearSearchProvider()),
        ChangeNotifierProvider(create: (_) => BinarySearchProvider()),
        ChangeNotifierProvider(create: (_) => BubbleSortProvider()),
        ChangeNotifierProvider(create: (_) => SelectionSortProvider()),
        ChangeNotifierProvider(create: (_) => InsertionSortProvider()),
        ChangeNotifierProvider(create: (_) => QuickSortProvider()),
      ],
      child: MaterialApp(
        title: 'Visualize Data Structures',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: Fonts.lato,
          textTheme: Theme.of(context).textTheme.apply(
                displayColor: Colors.white,
                bodyColor: Colors.white,
              ),
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        AppUtils.screenType = sizingInfo.deviceScreenType;
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Row(
            children: <Widget>[
              if (sizingInfo.isDesktop) NavBar(),
              HomeContent(),
            ],
          ),
          drawer: !sizingInfo.isDesktop ? NavBar() : null,
        );
      },
    );
  }
}
