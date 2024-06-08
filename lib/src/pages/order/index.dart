import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/api/order.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';

import '../../components/layout/order/OrdersCard.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  dynamic orderList = [];
  bool loading = false;
  late dynamic args = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initLoad();
  }

  initLoad() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments;
      });
      debugPrint("args $args");
      if (args != null) {
        debugPrint("args1 $args");
        if (args['is_received'] != null && args['is_received'] == 1) {
          getOrdersItems(is_received: true);
        }
      } else {
        getOrdersItems(is_received: false);
      }
    });
  }

  getOrdersItems({is_received = false}) {
    setState(() {
      loading = true;
    });
    getOrders(is_received).then((value) => {
          setState(() {
            loading = false;
            orderList = value['data'];
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    renderOrdersList() {
      if (orderList.length > 0) {
        return Expanded(
          child: CustomListView(
            hasData: orderList != null && orderList.length ? true : false,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: orderList != null ? orderList.length : 0,
                addRepaintBoundaries: true,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return OrdersCard(
                    item: {
                      ...orderList[index],
                      "is_received": args != null && args['is_received'] != null
                          ? args['is_received']
                          : 0
                    },
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

    return FocusDetector(
      onFocusGained: () => {initLoad()},
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: args != null &&
                  args['is_received'] != null &&
                  args['is_received'] == 1
              ? "Received Orders"
              : "Orders",
        ),
        body: PageLoader(
          loading: loading,
          child: Container(
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                renderOrdersList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
