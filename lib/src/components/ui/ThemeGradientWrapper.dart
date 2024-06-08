import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeGradientWrapper extends StatefulWidget {
  final Widget child;
  const ThemeGradientWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<ThemeGradientWrapper> createState() => _ThemeGradientWrapperState();
}

class _ThemeGradientWrapperState extends State<ThemeGradientWrapper> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 1],
        colors: [
          themeData.primaryColor,
          themeData.primaryColorDark,
        ],
      ).createShader(bounds),
      child: widget.child,
    );
  }
}
