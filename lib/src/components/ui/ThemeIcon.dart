import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThemeIcon extends StatefulWidget {
  final Widget child;
  const ThemeIcon({Key? key,required this.child}) : super(key: key);

  @override
  State<ThemeIcon> createState() => _ThemeIconState();
}

class _ThemeIconState extends State<ThemeIcon> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return ShaderMask(
        blendMode: BlendMode.srcIn,

        shaderCallback: (Rect bounds) => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 1],
          colors: [
            themeData.primaryColor,
            themeData.primaryColorDark,
          ],
        ).createShader(bounds),
        child:widget.child);
  }
}
