import 'package:flutter/material.dart';

class CrossFade<T> extends StatefulWidget {
  final T initialData;
  final T data;
  final Duration duration;
  final Widget Function(T data) builder;
  final VoidCallback onFadeComplete;

  CrossFade({
    @required this.initialData,
    @required this.data,
    @required this.builder,
    this.duration = const Duration(milliseconds: 300),
    this.onFadeComplete,
  });

  @override
  _CrossFadeState<T> createState() => _CrossFadeState<T>();
}

class _CrossFadeState<T> extends State<CrossFade<T>>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  T dataToShow;

  @override
  void initState() {
    super.initState();
    dataToShow = widget.initialData;
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          dataToShow = widget.data;
          controller.reverse(from: 1.0);
        } else if (status == AnimationStatus.dismissed) {
          if (widget.onFadeComplete != null) widget.onFadeComplete();
        }
      });


    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CrossFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    dataToShow = oldWidget.data;
    if (!_isTransitioning) {
      controller.forward(from: 0.0);
    }
  }

  bool get _isTransitioning =>
      controller.status == AnimationStatus.forward ||
      controller.status == AnimationStatus.reverse;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1.0 - animation.value,
      child: widget.builder(dataToShow),
    );
  }
}
