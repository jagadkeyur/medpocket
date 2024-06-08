import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/product/ProductCard.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';

class ProductList extends StatefulWidget {
  final dynamic listData;
  const ProductList({Key? key, this.listData}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
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
            return ProductCard(
              item: widget.listData[index],
            );
          }),
    );
  }
}
