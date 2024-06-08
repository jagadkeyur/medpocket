import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatefulWidget {
  const NewsDetailsPage({Key? key}) : super(key: key);

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  dynamic item;
  late dynamic args;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments;
        debugPrint("args $args");
        if (args != null) {
          debugPrint("args1 $args");
          item = args['news'];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    if (item == null) return Container();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'News Detail',
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    item['messageHeader'] ?? "",
                    style: themeData.textTheme.headlineSmall
                        ?.copyWith(color: themeData.primaryColor),
                  )),
              CardWrapper(
                  // elevation: 3,
                  //   margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "Description",
                        style: themeData.textTheme.bodyLarge
                            ?.copyWith(color: themeData.primaryColor),
                      ),
                    ),
                    Html(
                      data: item['messageDetail'] ?? "",
                    ),
                  ],
                ),
              )),
              CardWrapper(
                  // elevation: 3,
                  //   margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "Attachments",
                        style: themeData.textTheme.bodyLarge
                            ?.copyWith(color: themeData.primaryColor),
                      ),
                    ),
                    InkWell(
                      child: Text(
                        item['attachments'] ?? "",
                        style: themeData.textTheme.bodyMedium
                            ?.copyWith(color: themeData.primaryColorDark),
                      ),
                      onTap: () {
                        launchUrl(
                            Uri.parse(item['attachments']
                                .toString()
                                .replaceAll('\\', '/')),
                            mode: LaunchMode.externalNonBrowserApplication);
                      },
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
