import 'package:flutter/material.dart';
import 'package:medpocket/src/api/profile.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';

class CenterSpeechPage extends StatefulWidget {
  const CenterSpeechPage({Key? key}) : super(key: key);

  @override
  State<CenterSpeechPage> createState() => _CenterSpeechPageState();
}

class _CenterSpeechPageState extends State<CenterSpeechPage> {
  dynamic centerAdsList = [];
  dynamic user;
  int selectedPage = 0;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() {
    setState(() {
      loading = true;
    });
    getProfile().then((value) => {
          setState(() {
            user = value['data'];
            loading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageLoader(
        loading: loading,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  height: 200,
                  child: user != null && user['header'] != null
                      ? Image.network(
                          user['header'],
                          fit: BoxFit.fitWidth,
                        )
                      : Container()),
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: ThemeButton(
                  onClick: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/center-ads',
                        (Route<dynamic> route) => false);
                  },
                  text: "Skip",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
