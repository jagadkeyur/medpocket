import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medpocket/src/api/company.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/layout/SearchBox.dart';
import 'package:medpocket/src/components/layout/company/CompanyList.dart';
import 'package:stream_transform/stream_transform.dart';

class CompanyStockiest extends StatefulWidget {
  const CompanyStockiest({Key? key}) : super(key: key);

  @override
  State<CompanyStockiest> createState() => _CompanyStockiestState();
}

class _CompanyStockiestState extends State<CompanyStockiest> {
  StreamController<String> streamController = StreamController();
  final searchText = TextEditingController();
  late dynamic listData = [];
  late dynamic args = null;
  bool loading = false;
  @override
  initState() {
    super.initState();
    streamController.stream.debounce(const Duration(seconds: 1)).listen((s) => {
          // your code
          if (s.length > 2)
            {
              setState(() {
                loading = true;
              }),
              companyToStockiest(s).then((value) => {
                    setState(() {
                      loading = false;
                      listData = value['data'];
                    })
                  })
            }
          else
            {
              setState(() {
                loading = false;
                listData = [];
              })
            }
        });
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments;
      });
      debugPrint("args $args");
      if (args != null) {
        debugPrint("args1 $args");
        if (args['firmName'] != null) {
          setState(() {
            loading = true;
          });
          companyFromStockiest(args['firmName']).then((value) => {
                setState(() {
                  loading = false;
                  listData = value['data'];
                })
              });
        }
        if (args['searchText'] != null) {
          debugPrint("search Text ${args['searchText']}");
          searchText.text = args['searchText'];
          streamController.add(args['searchText']);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    getSearchBox() {
      if (args == null || (args != null && args['searchText'] != null)) {
        return SearchBox(
          streamController: streamController,
          textEditingController: searchText,
        );
      } else {
        return Container();
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: args == null || (args != null && args['searchText'] != null)
            ? "Company To Stockiest"
            : args['firmName'],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox.expand(
          child: Column(
            children: [
              getSearchBox(),
              Expanded(
                child: PageLoader(
                  loading: loading,
                  child: CompanyList(
                    listData: listData,
                    stockiest: true,
                    args: args,
                  ),
                ),
              )
              //
            ],
          ),
        ),
      ),
    );
  }
}
