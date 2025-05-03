import 'dart:io';

import 'package:context_holder/context_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/api/auth.dart';
import 'package:medpocket/src/api/profile.dart';
import 'package:medpocket/src/components/ui/ThemeGradientWrapper.dart';
import 'package:medpocket/src/pages/auth/key_validation/index.dart';
import 'package:medpocket/src/pages/auth/signin/index.dart';
import 'package:medpocket/src/pages/center_ads/index.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInit extends StatefulWidget {
  const AppInit({super.key});

  @override
  State<AppInit> createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  openAppUrl() {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? 'com.app.medpocket' : 'com.app.medpocket';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      debugPrint(
          "updateinfo ${info?.updateAvailability} ${UpdateAvailability.updateAvailable}");
      if (info?.updateAvailability == UpdateAvailability.updateAvailable) {
        debugPrint("upd $info");
        return showDialog<void>(
          context: ContextHolder.currentContext,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("App Update Available"),
              content: const Text(
                  "New version of app available please update app for smooth experience."),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ContextHolder.currentContext).pop();
                    initScreens();
                  },
                ),
                TextButton(
                  child: const Text('Update'),
                  onPressed: () {
                    Navigator.of(ContextHolder.currentContext).pop();
                    initScreens();
                    openAppUrl();
                  },
                ),
              ],
            );
          },
        );
      } else {
        initScreens();
      }
    }).catchError((e) {
      showSnack(e.toString());
      initScreens();
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    checkForUpdate();
  }

  void initScreens() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      // log(token ?? "no token");
      String child = '/home';
      var user;
      Future.delayed(
          const Duration(seconds: 2),
          () async => {
                if (token == null)
                  {child = '/signin'}
                else
                  {
                    user = await getProfile(),
                    if (user['data'] == null)
                      {child = '/signin'}
                    else
                      {
                        debugPrint('user ${user['data']['reg_key']}'),
                        if (user['data']['reg_key'] == null)
                          child = '/key-validate',
                        if (user['data']['active'] == 0)
                          {child = '/signin', prefs.remove('token')}
                      }
                  },
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  child,
                  (Route<dynamic> route) => false,
                )
              });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    var children = [
      Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 200,
                child: ThemeGradientWrapper(
                    child: Image.asset(
                  'lib/src/assets/images/icon-transparent-bg.png',
                  fit: BoxFit.fitHeight,
                ))),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: ThemeGradientWrapper(
                    child: Text("MedPocket",
                        style: themeData.textTheme.headlineLarge
                            ?.copyWith(color: themeData.primaryColor)))),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: ThemeGradientWrapper(
                    child: Text("A Pocket MediGuide",
                        style: themeData.textTheme.headlineSmall
                            ?.copyWith(color: themeData.primaryColor)))),
            Container(
              margin: EdgeInsets.symmetric(vertical: 50),
              width: 50,
              height: 50,
              child: ThemeGradientWrapper(
                child: LottieBuilder.network(
                    'https://lottie.host/941be6bb-483f-4588-835f-05597a9dcc58/vpAqu9ujNc.json',
                    frameRate: FrameRate.max,
                    fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Powered By",
                  style: themeData.textTheme.titleLarge
                      ?.copyWith(color: themeData.primaryColor, fontSize: 20),
                ),
              ),
              SizedBox(
                  height: 60,
                  child: Image.asset(
                    'assets/images/medisoft.png',
                    fit: BoxFit.fitHeight,
                  ))
            ],
          ),
        ),
      )
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      // backgroundColor: themeData.primaryColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      )),
    );
  }
}
