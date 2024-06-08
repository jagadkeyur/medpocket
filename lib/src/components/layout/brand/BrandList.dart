import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/brand/BrandCard.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';

class BrandList extends StatefulWidget {
  final dynamic listData;
  const BrandList({Key? key, this.listData}) : super(key: key);

  @override
  State<BrandList> createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  @override
  Widget build(BuildContext context) {
    return CustomListView(
      hasData: widget.listData.length > 0 ? true : false,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: widget.listData.length,
          addRepaintBoundaries: true,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return BrandCard(
              item: widget.listData[index],
            );
          }),
    );
  }
}
