import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medpocket/src/components/styles/CustomTextStyle.dart';

class ThemeButton extends StatefulWidget {
  final Function onClick;
  final String text;
  final bool loading;
  const ThemeButton(
      {Key? key, required this.onClick, this.text = "", this.loading = false})
      : super(key: key);

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    ThemeData? theme = Theme.of(context);
    return PhysicalModel(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      elevation: 3.0,
      shadowColor: Colors.primaries.last,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.primaryColor, theme.primaryColorDark],
              stops: const [0.0, 1],
            ),
          ),
          child: TextButton(
            onPressed: () => widget.onClick(),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
              child: ButtonTheme(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: body(context).copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    if (widget.loading) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                      )
                    ]
                  ],
                ),
              ),
            ),
          )),
    ).animate(onPlay: (controller)=>controller.repeat(reverse: false)).shimmer(color: Colors.white.withOpacity(0.2),duration: 3000.ms,delay: 1000.ms);
  }
}
