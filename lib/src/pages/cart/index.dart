import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/api/order.dart';
import 'package:medpocket/src/api/product.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/layout/product/CartCard.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  dynamic cartList = [];
  int? total = 0;
  bool cartLoading = false;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartItems();
  }

  getCartItems() {
    setState(() {
      loading = true;
    });
    getCart().then((value) => {
          setState(() {
            cartList = value['data'];
            loading = false;
            var sum = cartList.fold(0, (i, el) {
              return i + (int.parse(el['MRP'].split('.')[0]) * el['quantity']!);
            });
            debugPrint("sum $sum");
            total = sum;
          })
        });
  }

  deleteCartItem(item) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Remove Cart Item'),
            content: const Text('Are you sure to remove the item?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    deleteCart(item['cart_id']).then(
                        (value) => {if (value['status'] == 1) getCartItems()});
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    renderCartFooter() {
      if (cartList.length > 0) {
        return Expanded(
          flex: 0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, -2),
                      blurRadius: 5,
                      color: Colors.black12)
                ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 20, bottom: 10),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              stops: const [
                                0,
                                0.5
                              ],
                              colors: [
                                themeData.primaryColor,
                                themeData.primaryColorDark
                              ]),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Total",
                              style: themeData.textTheme.titleLarge
                                  ?.copyWith(color: themeData.primaryColorDark),
                            ),
                          ],
                        ),
                        Text(
                          "₹ ${total?.toStringAsFixed(2)}",
                          style: themeData.textTheme.titleLarge?.copyWith(
                              color: themeData.primaryColor, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ThemeButton(
                        onClick: () {
                          setState(() {
                            cartLoading = true;
                            placeOrder().then((value) => {
                                  cartLoading = false,
                                  getCartItems(),
                                  if (value['status'] == 1)
                                    {Navigator.pushNamed(context, '/orders')}
                                });
                          });
                        },
                        text: "Place Order",
                        loading: cartLoading,
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    }

    renderCartList() {
      if (cartList.length > 0) {
        return Expanded(
          child: CustomListView(
            hasData: cartList != null && cartList.length > 0 ? true : false,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: cartList != null ? cartList.length : 0,
                addRepaintBoundaries: true,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return CartCard(
                    item: cartList[index],
                    onDelete: (item) => deleteCartItem(item),
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: "Cart",
      ),
      body: PageLoader(
        loading: loading,
        child: Column(
          children: [renderCartList(), renderCartFooter()],
        ),
      ),
    );
  }
}
