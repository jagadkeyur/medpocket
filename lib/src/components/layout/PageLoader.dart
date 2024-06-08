import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../ui/ThemeGradientWrapper.dart';

class PageLoader extends StatefulWidget {
  final Widget child;
  final bool loading;
  const PageLoader({Key? key,this.loading=false,required this.child}) : super(key: key);

  @override
  State<PageLoader> createState() => _PageLoaderState();
}

class _PageLoaderState extends State<PageLoader> {
  @override
  Widget build(BuildContext context) {
    debugPrint("loading ${widget.loading}");
    if(widget.loading){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 150,
                child: ThemeGradientWrapper(
                    child: Image.asset(
                      'lib/src/assets/images/icon-transparent-bg.png',
                      fit: BoxFit.fitHeight,
                    ))),
            Container(
              // margin: const EdgeInsets.symmetric(vertical: 50),
              width: 100,
              height: 100,
              child: ThemeGradientWrapper(
                child: LottieBuilder.network(
                    'https://lottie.host/941be6bb-483f-4588-835f-05597a9dcc58/vpAqu9ujNc.json',
                    frameRate: FrameRate.max,
                    fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      );
    }
    else{
      return widget.child;
    }
  }
}
