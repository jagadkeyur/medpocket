import 'package:context_holder/context_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:medpocket/src/components/ui/ThemeIcon.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../api/order.dart';

class OrdersCard extends StatefulWidget {
  final dynamic item;

  const OrdersCard({Key? key, required this.item}) : super(key: key);

  @override
  State<OrdersCard> createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {
  updateOrderById(data, orderId) {
    updateOrder(data, orderId)
        .then((value) => {Navigator.of(ContextHolder.currentContext).pop()});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/order-details',
            arguments: {"order": widget.item});
      },
      child: CardWrapper(
        // elevation: 3,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10)
        // ),
        // margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                widget.item['order_id'].toString(),
                style: themeData.textTheme.headlineMedium
                    ?.copyWith(color: themeData.primaryColor),
              ),
              subtitle: Text(DateFormat.yMMMMd('en_US')
                  .format(DateTime.parse(widget.item['created']))),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹ ${widget.item['amount']}",
                    style: themeData.textTheme.titleLarge?.copyWith(
                        color: themeData.primaryColorDark, fontSize: 20),
                  ),
                ],
              ),
              leading: const ThemeIcon(
                child: Icon(
                  Icons.delivery_dining,
                  size: 50,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeData.primaryColorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      widget.item['txtStatus'],
                      style: themeData.textTheme.bodySmall
                          ?.copyWith(color: Colors.white),
                    )),
                  ),
                ),
                (widget.item['is_received'] == 0 && widget.item['status'] != 5)
                    ? ThemeButton(
                        onClick: () {
                          updateOrderById({"status": "5"}, widget.item['id']);
                        },
                        text: "Cancel Order")
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
