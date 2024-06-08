import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/api/company.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:medpocket/src/components/layout/SearchBox.dart';
import 'package:medpocket/src/components/layout/company/CompanyList.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../components/layout/PageLoader.dart';

class StockiestCompany extends StatefulWidget {
  const StockiestCompany({Key? key}) : super(key: key);

  @override
  State<StockiestCompany> createState() => _StockiestCompanyState();
}

class _StockiestCompanyState extends State<StockiestCompany> {
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
              stockiestToCompany(s).then((value) => {
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
        if (args['companyName'] != null) {
          stockiestFromCompany(args['companyName']).then((value) => {
                setState(() {
                  listData = value['data'];
                })
              });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    getSearchBox() {
      if (args == null) {
        return SearchBox(streamController: streamController);
      } else {
        return Container();
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: (args == null) ? "Stockiest To Company" : args['companyName'],
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
                  type: 'stockiest',
                  args: args,
                ),
              ))
              //
            ],
          ),
        ),
      ),
    );
  }
}
