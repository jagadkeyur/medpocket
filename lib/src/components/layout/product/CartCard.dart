import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';
import 'package:medpocket/src/components/ui/ThemeIcon.dart';

class CartCard extends StatefulWidget {
  final dynamic item;
  final Function(dynamic) onDelete;
  const CartCard({Key? key, required this.item, required this.onDelete})
      : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    num? quantity = widget.item['quantity'] ?? 1;
    debugPrint("$quantity");
    return CardWrapper(
      // margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      // elevation: 3,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            title: Text("${widget.item['BRAND']} - ${widget.item['FORM']}"),
            leading: const ThemeIcon(
                child: FaIcon(
              FontAwesomeIcons.capsules,
              size: 40,
            )),
            subtitle: Text(
              "₹ ${widget.item['MRP']}",
              style: themeData.textTheme.titleMedium
                  ?.copyWith(color: themeData.primaryColor),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: IconButton(
                        onPressed: () {
                          widget.onDelete(widget.item);
                        },
                        icon: const Icon(Icons.highlight_remove))),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.item['COMPANY']}",
                          style: themeData.textTheme.titleMedium),
                      Text("${widget.item['stockiest_id']}",
                          style: themeData.textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "₹ ${(double.parse(widget.item['MRP']) * quantity!).toStringAsFixed(2).toString()}",
                      style: themeData.textTheme.titleLarge
                          ?.copyWith(color: themeData.primaryColorDark),
                    ),
                  ),
                  InputQty(
                    onQtyChanged: (val) {
                      debugPrint("val $val");
                      Future.delayed(Duration.zero, () {
                        setState(() {
                          quantity = val;
                        });
                      });
                    },
                    initVal: quantity ?? 1,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
