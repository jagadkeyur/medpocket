// import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/api/profile.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';

import '../../api/auth.dart';

class CenterAdsPage extends StatefulWidget {
  const CenterAdsPage({Key? key}) : super(key: key);

  @override
  State<CenterAdsPage> createState() => _CenterAdsPageState();
}

class _CenterAdsPageState extends State<CenterAdsPage> {
  dynamic centerAdsList = [];
  dynamic user;
  int selectedPage = 0;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCenterAdsList();
  }

  getCenterAdsList() {
    setState(() {
      loading = true;
    });
    getProfile().then((value) => {
          setState(() {
            user = value['data'];
            getCenterAds().then((value) => {
                  setState(() {
                    centerAdsList = value['data'];
                    loading = false;
                  })
                });
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    // final controller = carousel_slider.CarouselController();
    ThemeData themeData = Theme.of(context);
    getSlider() {
      if (centerAdsList.length > 0) {
        // return carousel_slider.CarouselSlider.builder(
        //   itemCount: centerAdsList.length,
        //   itemBuilder:
        //       (BuildContext context, int itemIndex, int pageViewIndex) => Card(
        //     margin: const EdgeInsets.all(15),
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //     elevation: 5,
        //     clipBehavior: Clip.hardEdge,
        //     child: Image.network(
        //       centerAdsList[itemIndex]['attachment'],
        //       fit: BoxFit.fitWidth,
        //     ),
        //   ),
        //   carouselController: controller,
        //   options: carousel_slider.CarouselOptions(
        //       // height: MediaQuery.of(context).size.height-200,
        //       viewportFraction: 1.0,
        //       initialPage: 0,
        //       enableInfiniteScroll: true,
        //       reverse: false,
        //       autoPlay: true,
        //       autoPlayInterval: Duration(seconds: 3),
        //       autoPlayAnimationDuration: Duration(milliseconds: 800),
        //       autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
        //       enlargeCenterPage: true,
        //       enlargeFactor: 0.4,
        //       onPageChanged: (page, reason) => {
        //             setState(() {
        //               selectedPage = page;
        //             })
        //           },
        //       scrollDirection: Axis.horizontal,
        //       disableCenter: true,
        //       pageSnapping: true),
        // );
        return Container();
      } else {
        return Container();
      }
    }

    renderPagination({size = 10.0}) {
      List<Widget> data = [];
      for (int i = 0; i < centerAdsList.length; i++) {
        data.add(InkWell(
          onTap: () {
            // controller.animateToPage(i, duration: const Duration(seconds: 1));
          },
          child: Container(
            width: size,
            height: size,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
            decoration: BoxDecoration(
                color: selectedPage == i ? Colors.black45 : Colors.black12,
                borderRadius: BorderRadius.circular(size)),
          ),
        ));
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: data,
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageLoader(
          loading: loading,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: getSlider(),
              ),
              Expanded(flex: 0, child: renderPagination()),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: ThemeButton(
                    onClick: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (Route<dynamic> route) => false);
                    },
                    text: "Skip",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
