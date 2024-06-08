import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';
import 'package:medpocket/src/components/ui/ThemeIcon.dart';
import 'package:intl/date_symbol_data_local.dart';

class OrderDetailCard extends StatefulWidget {
  final dynamic item;
  const OrderDetailCard({Key? key,required this.item}) : super(key: key);

  @override
  State<OrderDetailCard> createState() => _OrderDetailCardState();
}

class _OrderDetailCardState extends State<OrderDetailCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData=Theme.of(context);
    renderRow({label,value,active =false,divider =true}){
      return Container(
        color: active?Colors.black12:Colors.transparent,
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(label,style: themeData.textTheme.titleMedium?.copyWith(color: themeData.primaryColor,fontSize: active?24:16),)),
                  Expanded(flex:0,child: Text(value,style: themeData.textTheme.titleMedium?.copyWith(color: Colors.black54,fontSize: active?24:16),)),
                ],
              ),
            ),
            divider ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
              child: Divider(height: 2,color: themeData.primaryColorLight,),
            ):Container(),
          ],
        ),
      );
    }
    return CardWrapper(
        // elevation: 3,
        // clipBehavior: Clip.hardEdge,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10)
        // ),
        // margin: EdgeInsets.only(left: 15,right: 15,bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              title: Text(widget.item['stockiest_id'].toString(),style:themeData.textTheme.titleLarge?.copyWith(color: themeData.primaryColor) ,),
              subtitle: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(widget.item['created']))),

              leading: ThemeIcon(
                child: Icon(
                  Icons.person,size: 25,
                ),
              ),
            ),
            renderRow(label: "Brand",value: widget.item['BRAND']),
            renderRow(label: "Form",value: widget.item['FORM']),
            renderRow(label: "Company",value: widget.item['COM_FULL']),
            renderRow(label: "MRP",value: "₹ ${widget.item['MRP']}"),
            renderRow(divider:false,label: "Quantity",value: widget.item['quantity'].toString()),
            renderRow(divider:false,label: "Total",value:"₹ ${(int.parse(widget.item['MRP'].split('.')[0]) * widget.item['quantity']!).toStringAsFixed(2).toString()}",active: true),
          ],
        ),

    );
  }
}
