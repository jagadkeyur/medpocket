import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/pages/about/index.dart';
import 'package:medpocket/src/pages/dashboard/index.dart';
import 'package:medpocket/src/pages/news/index.dart';
import 'package:medpocket/src/pages/profile/index.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _index = 0;
  late dynamic args = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments;
      });
      debugPrint("args $args");
      if (args != null) {
        debugPrint("args1 $args");
        if (args['index'] != null) {
          _index = args['index'];
        }
      }
    });
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure to exit app?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    String title = "Home";
    Widget child = Container();
    Color? primaryColor = Theme.of(context).primaryColor;
    Color? primaryColorDark = Theme.of(context).primaryColorDark;
    switch (_index) {
      case 0:
        child = const Dashboard();
        title = "Home";
        break;
      case 1:
        child = const ProfilePage();
        title = "Profile";
        break;
      case 2:
        child = const NewsPage();
        title = "News";
        break;
      case 3:
        child = const AboutUsPage();
        title = "About us";
        break;
    }

    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        // backgroundColor: const Color(0xffeeeeee),
        appBar: CustomAppBar(
          title: title,
        ),
        body: Container(
            padding: EdgeInsets.only(top: 100),
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover,
                    opacity: 1,
                    colorFilter: ColorFilter.mode(
                        themeData.primaryColor.withOpacity(0.5),
                        BlendMode.lighten))),
            child: SizedBox.expand(child: child)),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: ClipRRect(
            child: BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    //   gradient: LinearGradient(
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //       colors: [themeData.primaryColor.withOpacity(0.3),themeData.primaryColorDark.withOpacity(0.3)]
                    //   ),
                    borderRadius: BorderRadius.circular(10),
                    border: GradientBoxBorder(
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          stops: const [
                            0,
                            0.5
                          ],
                          colors: [
                            themeData.primaryColorDark,
                            themeData.primaryColor,
                          ]),
                      width: 1.5,
                    )),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  currentIndex: _index,
                  onTap: (value) {
                    setState(() {
                      _index = value;
                    });
                  },
                  elevation: 0,
                  showUnselectedLabels: false,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: Colors.white.withOpacity(0.8),
                  items: [
                    BottomNavigationBarItem(
                      backgroundColor: Colors.transparent,
                      icon: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) => LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0, 1],
                                colors: [
                                  primaryColor,
                                  primaryColorDark,
                                ],
                              ).createShader(bounds),
                          child: const Icon(Icons.home)),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                        backgroundColor: Colors.transparent,
                        icon: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: const [0, 1],
                                  colors: [
                                    primaryColor,
                                    primaryColorDark,
                                  ],
                                ).createShader(bounds),
                            child: const Icon(Icons.person_outline)),
                        label: "Profile"),
                    BottomNavigationBarItem(
                        backgroundColor: Colors.transparent,
                        icon: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: const [0, 1],
                                  colors: [
                                    primaryColor,
                                    primaryColorDark,
                                  ],
                                ).createShader(bounds),
                            child: const Icon(Icons.newspaper)),
                        label: "News"),
                    BottomNavigationBarItem(
                        backgroundColor: Colors.transparent,
                        icon: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: const [0, 1],
                                  colors: [
                                    primaryColor,
                                    primaryColorDark,
                                  ],
                                ).createShader(bounds),
                            child: const Icon(Icons.info_outline)),
                        label: "About Us"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
