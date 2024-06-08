import 'package:flutter/material.dart';
import 'package:medpocket/src/api/company.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';

class AddCartCompanyList extends StatefulWidget {
  final String company;
  final Function onClick;
  final String selectedItem;
  const AddCartCompanyList(
      {Key? key,
      required this.company,
      required this.onClick,
      this.selectedItem = ""})
      : super(key: key);

  @override
  State<AddCartCompanyList> createState() => _AddCartCompanyListState();
}

class _AddCartCompanyListState extends State<AddCartCompanyList> {
  dynamic data = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    Future.delayed(Duration.zero, () {
      companyToStockiest(widget.company).then((value) => {
            setState(() => {
                  loading = false,
                  data = value['data'],
                  debugPrint("data $data ${widget.company}")
                })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return PageLoader(
      loading: loading,
      child: SingleChildScrollView(
        child: CustomListView(
          hasData: data.length > 0 ? true : false,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              addRepaintBoundaries: true,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                return ListTile(
                  selected:
                      item['COMPANY_NAME'].toString() == widget.selectedItem,
                  selectedTileColor: Colors.black12,
                  selectedColor: themeData.primaryColor,
                  title: Text(item['COMPANY_NAME']),
                  onTap: () {
                    widget.onClick(item);
                  },
                  trailing:
                      item['COMPANY_NAME'].toString() == widget.selectedItem
                          ? Icon(
                              Icons.check,
                              color: themeData.primaryColor,
                            )
                          : null,
                );
              }),
        ),
      ),
    );
  }
}
