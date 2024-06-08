import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/api/company.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/layout/SearchBox.dart';
import 'package:medpocket/src/components/layout/company/CompanyList.dart';
import 'package:stream_transform/stream_transform.dart';

class CompanySearch extends StatefulWidget {

  const CompanySearch({Key? key}) : super(key: key);

  @override
  State<CompanySearch> createState() => _CompanySearchState();
}

class _CompanySearchState extends State<CompanySearch> {
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
          companySearch(s).then((value) => {
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
        title: "Company Search",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox.expand(
          child: Column(
            children: [
              SearchBox(streamController: streamController),
              Expanded(
                child:PageLoader(loading: loading, child: CompanyList(listData: listData,)) ,
              )
              //
            ],
          ),
        ),
      ),
    );
  }
}
