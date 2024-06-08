import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/api/company.dart';
import 'package:medpocket/src/api/generic.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/layout/SearchBox.dart';
import 'package:medpocket/src/components/layout/company/CompanyList.dart';
import 'package:medpocket/src/components/layout/generic/GenericList.dart';
import 'package:stream_transform/stream_transform.dart';

class GenericSearch extends StatefulWidget {

  const GenericSearch({Key? key}) : super(key: key);

  @override
  State<GenericSearch> createState() => _GenericSearchState();
}

class _GenericSearchState extends State<GenericSearch> {
  StreamController<String> streamController = StreamController();
  final searchText = TextEditingController();
  late dynamic listData=[];
  bool loading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamController.stream.debounce(const Duration(seconds: 1)).listen((s) => {
      // your code
      if (s.length > 2)
        {
          setState(() {
            loading = true;
          }),
          genericSearch(s).then((value) => {
            setState(() {
              loading=false;
              listData=value['data'];
            })
          })
        }else{
        setState((){
          loading=false;
          listData=[];
        })
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CustomAppBar(
        title: "Generic Search",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox.expand(
          child: Column(
            children: [
              SearchBox(streamController: streamController),
              Expanded(
                child:PageLoader(loading: loading, child: GenericList(listData: listData,)) ,
              )
              //
            ],
          ),
        ),
      ),
    );
  }
}
