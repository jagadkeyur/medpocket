import 'package:flutter/material.dart';
import 'package:medpocket/src/api/company.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';

class AddCartStockiestList extends StatefulWidget {
  final String company;
  final Function onClick;
  final String selectedItem;
  const AddCartStockiestList(
      {Key? key,
      required this.company,
      required this.onClick,
      this.selectedItem = ""})
      : super(key: key);

  @override
  State<AddCartStockiestList> createState() => _AddCartStockiestListState();
}

class _AddCartStockiestListState extends State<AddCartStockiestList> {
  dynamic data = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    stockiestFromCompany(widget.company).then((value) => {
          setState(() => {loading = false, data = value['data']})
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return PageLoader(
      loading: loading,
      child: CustomListView(
        hasData: data.length > 0 ? true : false,
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: data.length,
            addRepaintBoundaries: true,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (BuildContext context, int index) {
              final item = data[index];
              return ListTile(
                selected: item['FIRM_NAME'].toString() == widget.selectedItem,
                selectedTileColor: Colors.black12,
                selectedColor: themeData.primaryColor,
                title: Text(item['FIRM_NAME']),
                onTap: () {
                  widget.onClick(item);
                },
                trailing: item['FIRM_NAME'].toString() == widget.selectedItem
                    ? Icon(
                        Icons.check,
                        color: themeData.primaryColor,
                      )
                    : null,
              );
            }),
      ),
    );
  }
}
