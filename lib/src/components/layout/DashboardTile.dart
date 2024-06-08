import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medpocket/src/components/layout/CircleWrapper.dart';
import 'package:medpocket/src/components/styles/CustomTextStyle.dart';

class DashboardTile extends StatefulWidget {
  final Widget icon;
  final String label;
  final Function onClick;
  final int index;
  const DashboardTile(
      {Key? key,
      required this.icon,
      required this.index,
      required this.label,
      required this.onClick})
      : super(key: key);

  @override
  State<DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return CircleWrapper(
      child: InkWell(
        onTap: () => widget.onClick(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
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
                child: widget.icon),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
              child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) => LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 1],
                        colors: [
                          themeData.primaryColor,
                          Colors.black87,
                        ],
                      ).createShader(bounds),
                  child: Center(
                      child: Text(
                    widget.label,
                    style: const TextStyle(color: Colors.red,fontSize: 16),
                    textAlign: TextAlign.center,
                  ))),
            )
          ],
        ),
      ),
    ).animate()
        .fadeIn(delay: (widget.index*100).ms) // uses `Animate.defaultDuration`
        .slideY(duration: 100.ms,delay: (widget.index*100).ms,begin: 1,end: 0)
        .slideX(duration: 100.ms,delay: (widget.index*100).ms);
  }
}
