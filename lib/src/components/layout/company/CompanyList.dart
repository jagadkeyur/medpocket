import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/company/CompanyCard.dart';
import 'package:medpocket/src/components/layout/company/CompanyStockiestCard.dart';
import 'package:medpocket/src/components/layout/company/StockiestCompanyCard.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';

class CompanyList extends StatefulWidget {
  final dynamic listData;
  final bool stockiest;
  final String type;
  final dynamic args;
  const CompanyList(
      {Key? key,
      this.listData,
      this.stockiest = false,
      this.type = "company",
      this.args})
      : super(key: key);

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
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
            return !widget.stockiest
                ? CompanyCard(
                    item: widget.listData[index],
                  )
                : (widget.type == 'company')
                    ? CompanyStockiestCard(
                        item: widget.listData[index],
                        args: widget.args,
                      )
                    : StockiestCompanyCard(
                        item: widget.listData[index],
                        args: widget.args,
                      );
          }),
    );
  }
}
