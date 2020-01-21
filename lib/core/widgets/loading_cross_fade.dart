import 'package:flutter/material.dart';

import 'cross_fade.dart';

class LoadingCrossFade extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool isLoaded;
  final bool centerProgressBar;

  const LoadingCrossFade({
    Key key,
    @required this.isLoaded,
    @required this.child,
    this.centerProgressBar = true,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _LoadingCrossFadeState createState() => _LoadingCrossFadeState();
}

class _LoadingCrossFadeState extends State<LoadingCrossFade> {
  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = CircularProgressIndicator();
    if (widget.centerProgressBar)
        loadingWidget = Center(child: loadingWidget);

    return CrossFade<bool>(
      duration: widget.duration,
      initialData: widget.isLoaded,
      data: widget.isLoaded,
      builder: (bool isLoaded) {
        return isLoaded ? widget.child : loadingWidget;
      },
    );
  }
}
