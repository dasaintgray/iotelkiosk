import 'package:flutter/material.dart';

/// Create the custom widget for AppBar Gradient
/// Author: Henry V. Mempin
/// Date: 7 December, 2022
/// email: henrymempin@gmail.com

class HVMGradientAppBar extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<Color> colors;
  final TileMode tileMode;

  const HVMGradientAppBar({
    super.key,
    required this.colors,
    this.child,
    this.begin = Alignment.bottomCenter,
    this.end = Alignment.topCenter,
    this.tileMode = TileMode.clamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
          // stops: const [0.0, 1.0],
          tileMode: tileMode,
        ),
      ),
      child: child,
    );
  }
}
