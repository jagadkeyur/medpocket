import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/chemist_drugist/ChemistDrugistCard.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';

class ChemistDrugistList extends StatefulWidget {
  final dynamic listData;
  const ChemistDrugistList({Key? key, this.listData}) : super(key: key);

  @override
  State<ChemistDrugistList> createState() => _ChemistDrugistListState();
}

class _ChemistDrugistListState extends State<ChemistDrugistList> {
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
            return ChemistDrugistCard(
              item: widget.listData[index],
            );
          }),
    );
  }
}
