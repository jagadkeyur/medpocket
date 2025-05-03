import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_shapes/header_shape.dart';
import 'BottomSheet.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color primaryColor = Theme.of(context).primaryColor;
    Color primaryColorDark = Theme.of(context).primaryColorDark;
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: themeData.textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Navigator.canPop(context)
            ? const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
              )
            : const Icon(
                Icons.menu,
                color: Colors.white,
              ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            ZoomDrawer.of(context)?.toggle();
          }
        },
      ),
      automaticallyImplyLeading: true,
      elevation: 0,
      toolbarHeight: 70,
      actions: [
        IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context,
                          StateSetter setState /*You can rename this!*/) {
                        return CustomBottomSheet(
                            title: "More",
                            footer: Container(),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "Share App",
                                    style: themeData.textTheme.bodyLarge,
                                  ),
                                  onTap: () async {
                                    var result = await Share.share(
                                        'Let me recommend you this application https://play.google.com/store/apps/details?id=com.app.medpocket');

                                    if (result.status ==
                                        ShareResultStatus.success) {
                                      Fluttertoast.showToast(
                                          msg: "App Shared",
                                          toastLength: Toast.LENGTH_LONG);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                                ListTile(
                                  title: Text(
                                    "Share Feedback",
                                    style: themeData.textTheme.bodyLarge,
                                  ),
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                        'mailto:info@medpocket.in?subject=Feedback for medpocket app');
                                    if (!await launchUrl(url,
                                        mode: LaunchMode.externalApplication)) {
                                      Fluttertoast.showToast(
                                          msg: "Sorry feedback closed");
                                    }
                                  },
                                )
                              ],
                            ));
                      },
                    );
                  });
            },
            icon: const Icon(
              Icons.more_vert,
              size: 25,
              color: Colors.white,
            ))
      ],
      flexibleSpace: ClipPath(
        clipper: HeaderShape(),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black54, blurRadius: 100, spreadRadius: 100)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryColor, primaryColorDark])),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}
