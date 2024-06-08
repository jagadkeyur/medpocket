import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/components/ui/ThemeGradientWrapper.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ThemeGradientWrapper(
        child: LottieBuilder.asset(
          'assets/animations/nodata.json',
          width: 200,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
