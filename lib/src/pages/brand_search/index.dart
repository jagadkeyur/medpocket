import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/api/brand.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/layout/SearchBox.dart';
import 'package:medpocket/src/components/layout/brand/BrandList.dart';
import 'package:stream_transform/stream_transform.dart';

class BrandSearch extends StatefulWidget {
  const BrandSearch({Key? key}) : super(key: key);

  @override
  State<BrandSearch> createState() => _BrandSearchState();
}

class _BrandSearchState extends State<BrandSearch> {
  StreamController<String> streamController = StreamController();
  bool loading = false;
  final searchText = TextEditingController();
  late dynamic listData = [];
  late dynamic args = null;
  @override
  initState() {
    super.initState();
    streamController.stream.debounce(Duration(seconds: 1)).listen((s) => {
          // your code
          if (s.length > 2)
            {
              setState(() {
                loading = true;
              }),
              brandSearch(s).then((value) => {
                    setState(() {
                      loading = false;
                      listData = value['data'];
                    })
                  })
            }else{
            setState((){
              loading=false;
              listData=[];
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
        if (args['company'] != null) {
          setState(() {
            loading = true;
          });
          brandSearchByCompany(args['company']['COMPANY']).then((value) => {
                setState(() {
                  loading = false;
                  listData = value['data'];
                })
              });
        }
        if (args['generic'] != null) {
          setState(() {
            loading = true;
          });
          brandSearchByGeneric(args['generic']).then((value) => {
                setState(() {
                  loading = false;
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
        title: (args == null)
            ? "Brand Search"
            : (args != null && args['company'] != null)
                ? args['company']['COMPANY']
                : args['generic'],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox.expand(
          child: Column(
            children: [
              getSearchBox(),
              Expanded(
                child: PageLoader(
                  key: UniqueKey(),
                  loading: loading,
                  child: BrandList(
                    listData: listData,
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
