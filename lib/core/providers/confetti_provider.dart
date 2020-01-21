import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiProvider extends ChangeNotifier {
  OverlayEntry _overlayEntry;
  ConfettiController _controller;

  ConfettiController get controller => _controller;

  void initialize(BuildContext context, {int duration = 6}) {
    _controller = ConfettiController(duration: Duration(seconds: duration));
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry);
  }

  void playConfetti() => _controller.play();
  void stopConfetti() => _controller.stop();

  OverlayEntry _createOverlay() {
    double angle = 10;
    return OverlayEntry(
      builder: (_) {
        return Stack(
          children: <Widget>[
            // left
            Align(
              alignment: Alignment(-1, -0.6),
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: -angle * (pi / 180),
                emissionFrequency: 0.02,
                numberOfParticles: 12,
                minBlastForce: 72,
                maxBlastForce: 96,
                minimumSize: Size(8, 4),
                maximumSize: Size(14, 7),
              ),
            ),
            // right
            Align(
              alignment: Alignment(1, -0.6),
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: (180 - angle) * (-pi / 180),
                emissionFrequency: 0.02,
                numberOfParticles: 12,
                minBlastForce: 72,
                maxBlastForce: 96,
                minimumSize: Size(8, 4),
                maximumSize: Size(14, 7),
              ),
            ),
          ],
        );
      },
    );
  }
}
