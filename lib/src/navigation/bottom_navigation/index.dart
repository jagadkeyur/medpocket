import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:medpocket/src/components/layout/CustomDrawer.dart';

import 'bottom_nav.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final _drawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: CustomDrawer(),
      mainScreen: BottomNav(),
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      style: DrawerStyle.defaultStyle,
      // moveMenuScreen: true,
      borderRadius: 15,
      menuBackgroundColor: Colors.white,
      shadowLayer2Color: themeData.primaryColorLight.withOpacity(0.5),
      shadowLayer1Color: themeData.primaryColorDark.withOpacity(0.5),
      showShadow: true,
      menuScreenWidth: MediaQuery.of(context).size.width,
      mainScreenAbsorbPointer: true,
      // dragOffset: 100,
      menuScreenTapClose: true,
      mainScreenScale: 0.3,
      slideWidth: MediaQuery.of(context).size.width*(0.9),
      angle: 0,
    );
  }
}
