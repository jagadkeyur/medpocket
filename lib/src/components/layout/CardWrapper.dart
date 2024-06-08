import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class CardWrapper extends StatefulWidget {
  final Widget child;
  const CardWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<CardWrapper> createState() => _CardWrapperState();
}

class _CardWrapperState extends State<CardWrapper> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(left: 5,right: 5,bottom: 10),
      child: ClipRRect(
        child: BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: BoxDecoration(
                  // color: themeData.primaryColor.withOpacity(0.1),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white.withOpacity(0.2),themeData.primaryColorLight.withOpacity(0.2)]
                  ),

                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  // boxShadow: const [
                  //   BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 7,offset: Offset(5, 5)),
                  // ],
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        stops: [
                          0,
                          0.5,
                          0.7
                        ],
                        colors: [
                          themeData.primaryColor,
                          themeData.primaryColorDark,
                          themeData.primaryColor
                        ]),
                    width: 1,
                  ),
                ),
                child: widget.child,
              ),


        ).animate(onPlay: (controller)=>controller.repeat(reverse: false)).shimmer(color: Colors.white.withOpacity(0.3),duration: 3000.ms,delay: 1000.ms),
      ),
    );
  }
}
