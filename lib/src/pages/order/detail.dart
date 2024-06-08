import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/api/order.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/components/layout/order/OrderDetailCard.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';

import '../../api/profile.dart';
import '../../components/layout/BottomSheet.dart';
import '../../components/layout/order/OrdersCard.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  dynamic user;
  dynamic args;
  dynamic orderList = [];
  dynamic orderStatusList = [];
  int selectedStatus = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments;
      });
    });
    initLoad();
  }

  initLoad() {
    Future.delayed(Duration.zero, () {
      getUserProfile();
      getOrderStatuses();
      setState(() {
        debugPrint("args $args");
        if (args != null) {
          debugPrint("args1 $args");
          if (args['order'] != null) {
            getOrdersItems(args['order']['order_id']);
            setState(() {
              selectedStatus = args['order']['status'];
            });
          }
        }
      });
    });
  }

  getOrdersItems(orderId) {
    getOrderById(orderId).then((value) => {
          setState(() {
            orderList = value['data'];
          })
        });
  }

  getOrderStatuses() {
    getOrderStatus().then((value) => {
          setState(() {
            orderStatusList = value['data'];
          })
        });
  }

  getUserProfile() {
    getProfile().then((value) => {
          if (value['status'] == 1)
            {
              setState(() {
                user = value['data'];
              })
            }
        });
  }

  updateOrderById(data, orderId) {
    updateOrder(data, orderId).then((value) => {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    renderOrdersList() {
      if (orderList.length > 0) {
        return Expanded(
          child: CustomListView(
            hasData: orderList != null && orderList.length > 0 ? true : false,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: orderList != null ? orderList.length : 0,
                addRepaintBoundaries: true,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return OrderDetailCard(
                    item: orderList[index],
                  );
                }),
          ),
        );
      } else {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                    'https://lottie.host/eaae85ef-7baf-43ee-a3f9-6d25be4b0767/tQWP9GFeqr.json',
                    width: 300),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No Items Found",
                    style: themeData.textTheme.headlineSmall
                        ?.copyWith(color: themeData.primaryColor),
                  ),
                )
              ],
            ),
          ),
        );
      }
    }

    renderAction() {
      if (args != null &&
          args['order'] != null &&
          args['order']['is_received'] == 1 &&
          user != null &&
          user['is_stockiest'] == 1) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ThemeButton(
            onClick: () => {
              showModalBottomSheet<void>(
                  context: context,
                  useRootNavigator: true,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context,
                          StateSetter setState /*You can rename this!*/) {
                        return CustomBottomSheet(
                            title: "Update Order Status",
                            footer: Container(),
                            child: Column(
                              children: [
                                Expanded(
                                  child: CustomListView(
                                    hasData: orderStatusList.length > 0
                                        ? true
                                        : false,
                                    child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: orderStatusList.length,
                                        addRepaintBoundaries: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final item = orderStatusList[index];
                                          return ListTile(
                                            selected:
                                                item['ID'] == selectedStatus,
                                            selectedTileColor: Colors.black12,
                                            selectedColor:
                                                themeData.primaryColor,
                                            title: Text(item['Desc']),
                                            onTap: () => {
                                              setState(() {
                                                selectedStatus = item['ID'];
                                                var newArgs = {
                                                  "order": {
                                                    ...args['order'],
                                                    "txtStatus": item['Desc'],
                                                    "status": item['ID']
                                                  }
                                                };
                                                args = newArgs;

                                                updateOrderById({
                                                  "status":
                                                      item['ID'].toString()
                                                }, args['order']['id']);
                                                Navigator.pop(context);
                                                initLoad();
                                              })
                                            },
                                            trailing: item['ID'] ==
                                                    selectedStatus
                                                ? Icon(
                                                    Icons.check,
                                                    color:
                                                        themeData.primaryColor,
                                                  )
                                                : null,
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ));
                      },
                    );
                  })
            },
            text: "Update Order",
          ),
        );
      } else {
        return Container();
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: "Order Details",
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            OrdersCard(key: Key('card'), item: args['order'] ?? {}),
            renderOrdersList(),
            renderAction()
          ],
        ),
      ),
    );
  }
}
