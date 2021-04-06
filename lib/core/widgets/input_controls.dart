import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualize_data_structures/core/providers/input_controls_provider.dart';

class InputControls extends StatefulWidget {
  final Widget child;

  const InputControls({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _InputControlsState createState() => _InputControlsState();
}

class _InputControlsState extends State<InputControls> {
  late FocusNode focusNode;
  late InputControlsProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    focusNode = FocusNode();
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<InputControlsProvider>(context);
    return RawKeyboardListener(
      focusNode: focusNode,
      child: widget.child,
      onKey: provider.updateKeyEvent,
    );
  }
}
