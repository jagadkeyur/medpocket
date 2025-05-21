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
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _index = 0;
  dynamic args;

  @override
  void initState() {
    super.initState();
    // Delay to get arguments after widget build
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments;
      });
      if (args != null && args['index'] != null) {
        setState(() {
          _index = args['index'];
        });
      }
    });
  }

  Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to exit the app?'),
                actions: [
                  // The "Yes" button
                  TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    String title = "Home";
    Widget child = const Dashboard();

    // Switch between pages based on selected index
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
        title = "About Us";
        break;
    }

    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        key: _key,
        extendBodyBehindAppBar: true,
        extendBody: false,
        appBar: CustomAppBar(title: title),
        body: Container(
          padding: const EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
              opacity: 1,
              colorFilter: ColorFilter.mode(
                themeData.primaryColor.withOpacity(0.5),
                BlendMode.lighten,
              ),
            ),
          ),
          child: SizedBox.expand(child: child),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(0), // Remove margin
          padding: EdgeInsets.zero, // Remove padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white60,
            border: GradientBoxBorder(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: const [0, 0.5],
                colors: [
                  themeData.primaryColorDark,
                  themeData.primaryColor,
                ],
              ),
              width: 2.0,
            ),
          ),
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
            selectedItemColor: themeData.primaryColor,
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
                      themeData.primaryColor,
                      themeData.primaryColorDark
                    ],
                  ).createShader(bounds),
                  child: const Icon(Icons.home),
                ),
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
                      themeData.primaryColor,
                      themeData.primaryColorDark
                    ],
                  ).createShader(bounds),
                  child: const Icon(Icons.person_outline),
                ),
                label: "Profile",
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
                      themeData.primaryColor,
                      themeData.primaryColorDark
                    ],
                  ).createShader(bounds),
                  child: const Icon(Icons.newspaper),
                ),
                label: "News",
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
                      themeData.primaryColor,
                      themeData.primaryColorDark
                    ],
                  ).createShader(bounds),
                  child: const Icon(Icons.info_outline),
                ),
                label: "About Us",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
