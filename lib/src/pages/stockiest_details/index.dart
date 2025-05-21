import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medpocket/src/api/company.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/ui/ThemeIcon.dart';
import 'package:url_launcher/url_launcher.dart';

class StockiestDetails extends StatefulWidget {
  const StockiestDetails({Key? key}) : super(key: key);

  @override
  State<StockiestDetails> createState() => _StockiestDetailsState();
}

class _StockiestDetailsState extends State<StockiestDetails> {
  bool loading = false;
  dynamic stockiest;
  dynamic args;
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        loading = true;
        args = ModalRoute.of(context)?.settings.arguments;
      });

      if (args != null) {
        if (args['stockiest'] != null) {
          getStockiestDetails(args['stockiest']).then((value) => {
                setState(() {
                  loading = false;
                }),
                if (value['data'] != null)
                  setState(() {
                    stockiest = value['data'];
                  })
              });
        }
        if (args['chemist'] != null) {
          setState(() {
            loading = false;
            stockiest = args['chemist'];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    renderStockiestHeader() {
      if (stockiest != null) {
        return Expanded(
            flex: 0,
            child: CardWrapper(
              // elevation: 3,
              // margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0, 1],
                          colors: [
                            themeData.primaryColor,
                            themeData.primaryColorDark,
                          ],
                        ).createShader(bounds),
                    child: const FaIcon(
                      FontAwesomeIcons.userLarge,
                      // size: 40,
                    )),
                title: Text(
                  "${stockiest['firm_name']}",
                  style: themeData.textTheme.titleMedium
                      ?.copyWith(color: themeData.primaryColor),
                ),
                subtitle: Text(
                  "${stockiest['address']}",
                  style: themeData.textTheme.bodyMedium
                      ?.copyWith(color: Colors.black45),
                ),
              ),
            ));
      } else {
        return Container();
      }
    }

    renderRow(
        {title = "", value = "", icon = null, isLink = false, onTap = null}) {
      if (stockiest != null) {
        renderValue() {
          return Text(
            value ?? "-",
            style: themeData.textTheme.bodyMedium?.copyWith(
                color: isLink ? themeData.primaryColorDark : Colors.black45),
          );
        }

        return Expanded(
            flex: 0,
            child: CardWrapper(
              // elevation: 3,
              // margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  title ?? "",
                  style: themeData.textTheme.titleMedium
                      ?.copyWith(color: themeData.primaryColor),
                ),
                subtitle: isLink
                    ? InkWell(
                        onTap: onTap,
                        child: renderValue(),
                      )
                    : renderValue(),
                leading: icon,
              ),
            ));
      } else {
        return Container();
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: "Stockiest Details",
      ),
      body: SingleChildScrollView(
        child: PageLoader(
          loading: loading,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                renderStockiestHeader(),
                renderRow(
                    title: "Center",
                    value: stockiest != null ? stockiest['CENTER'] : "",
                    icon: const ThemeIcon(child: Icon(Icons.map))),
                renderRow(
                    title: "City",
                    value: stockiest != null ? stockiest['CITY'] : "",
                    icon: const ThemeIcon(child: Icon(Icons.map))),
                renderRow(
                    title: "Contact Person",
                    value: stockiest != null ? stockiest['contact_person'] : "",
                    icon: const ThemeIcon(child: Icon(Icons.person_outline))),
                renderRow(
                    title: "Phone No.",
                    value: stockiest != null ? stockiest['phone_o'] : "",
                    isLink: true,
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'tel:${stockiest != null ? stockiest['phone_o'].split(",")[0] : ""}');
                      debugPrint("url $url");
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        Fluttertoast.showToast(msg: "Sorry number not found");
                      }
                    },
                    icon: const ThemeIcon(child: Icon(Icons.phone))),
                renderRow(
                    title: "Mobile No",
                    value: stockiest != null ? stockiest['mobile_no'] : "",
                    isLink: true,
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'tel:${stockiest != null ? stockiest['mobile_no'].split(",")[0] : ""}');
                      debugPrint("url $url");
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        Fluttertoast.showToast(msg: "Sorry number not found");
                      }
                    },
                    icon: const ThemeIcon(
                        child: FaIcon(FontAwesomeIcons.mobile))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
