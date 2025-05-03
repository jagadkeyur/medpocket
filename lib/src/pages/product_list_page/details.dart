import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:medpocket/src/api/product.dart';
import 'package:medpocket/src/components/layout/BottomSheet.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:medpocket/src/pages/product_list_page/add_cart_srockiest_list.dart';
import 'package:medpocket/src/pages/product_list_page/company_list.dart';

import '../../components/layout/AppBar.dart';
import '../../components/ui/ThemeIcon.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late dynamic args = null;
  late dynamic product = null;
  num? quantity = 1;
  String selectedCompany = "";
  dynamic selectedStockiest = null;
  bool cartLoading = false;
  bool loading = false;
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        loading = true;
        args = ModalRoute.of(context)?.settings.arguments;
      });

      if (args != null) {
        if (args['product'] != null) {
          productById(args['product']['ID']).then((value) => {
                setState(() {
                  loading = false;
                  product = value['data'];
                })
              });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    renderProductHeader() {
      if (product != null) {
        return Expanded(
            flex: 0,
            child: CardWrapper(
              // elevation: 3,
              // margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10)),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ListTile(
                    leading: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) => LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: const [0, 1],
                              colors: [
                                themeData.primaryColor,
                                themeData.primaryColorDark,
                              ],
                            ).createShader(bounds),
                        child: const FaIcon(
                          FontAwesomeIcons.capsules,
                          size: 30,
                        )),
                    title: Text("${product['BRAND']} - ${product['FORM']}"),
                    subtitle: InkWell(
                        onTap: () => {
                              Navigator.pushNamed(
                                  context, '/company-stockiest', arguments: {
                                "searchText": product['COM_FULL'].split(" ")[0]
                              })
                            },
                        child: Text(
                          "By ${product['COM_FULL']}",
                          style: themeData.textTheme.titleMedium
                              ?.copyWith(color: themeData.primaryColor),
                        )),
                    trailing: Text("₹ ${product['MRP']}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => {
                        Navigator.pushNamed(
                            context, '/brand-search', arguments: {
                          "generic": product != null ? product['CONTENT'] : ""
                        })
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              themeData.primaryColor,
                              themeData.primaryColorDark
                            ],
                            stops: const [0.0, 1],
                          ),
                        ),
                        child: Text(
                          "Substitute",
                          style: themeData.textTheme.labelLarge
                              ?.copyWith(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
      } else {
        return Container();
      }
    }

    renderRow({title = "", value = "", icon = null, onClick = null}) {
      if (product != null) {
        return Expanded(
            flex: 0,
            child: CardWrapper(
              // elevation: 3,
              // margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: icon,
                      ),
                    ),
                    Text(title ?? ""),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: onClick != null ? () => onClick() : () {},
                        child: Text(
                          value ?? "-",
                          style: themeData.textTheme.bodyMedium?.copyWith(
                              color: onClick == null
                                  ? Colors.black45
                                  : themeData.primaryColor),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      } else {
        return Container();
      }
    }

    quantityChange(val) {
      setState(() {
        quantity = val;
      });
    }

    onNextClick() {
      if (selectedCompany == "") {
        return Fluttertoast.showToast(
            msg: "Please select company",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      } else {
        return showModalBottomSheet<void>(
            context: context,
            useSafeArea: true,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context,
                    StateSetter setState /*You can rename this!*/) {
                  return CustomBottomSheet(
                      title: "Select Stockiest",
                      footer: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: ThemeButton(
                                text: "Add To Cart",
                                loading: cartLoading,
                                onClick: () {
                                  if (selectedStockiest == null) {
                                    Fluttertoast.showToast(
                                        msg: "Please select stockiest",
                                        toastLength: Toast.LENGTH_LONG);
                                  } else {
                                    final data = {
                                      "product_id": product['ID'].toString(),
                                      "stockiest_id":
                                          selectedStockiest['FIRM_NAME']
                                              .toString(),
                                      "quantity": quantity.toString(),
                                    };
                                    setState(() {
                                      cartLoading = true;
                                    });
                                    addToCart(data).then((value) => {
                                          setState(() {
                                            cartLoading = false;
                                          }),
                                          Navigator.pushNamed(context, '/cart')
                                        });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: AddCartStockiestList(
                              company: selectedCompany,
                              selectedItem: selectedStockiest != null
                                  ? selectedStockiest['FIRM_NAME']
                                  : "",
                              onClick: (val) {
                                setState(() {
                                  selectedStockiest = val;
                                });
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                // color: Colors.black26,
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "Quantity",
                                        style: themeData.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: InputQty(
                                    onQtyChanged: (val) => {
                                      Future.delayed(Duration.zero, () async {
                                        setState(() {
                                          quantity = val;
                                        });
                                      })
                                    },
                                    initVal: quantity ?? 1,
                                    btnColor1: themeData.primaryColor,
                                    btnColor2: themeData.primaryColor,
                                    textFieldDecoration: const InputDecoration(
                                        border: InputBorder.none),
                                    boxDecoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
                },
              );
            });
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CustomAppBar(
        title: "Product Detail",
      ),
      body: SingleChildScrollView(
        child: PageLoader(
          loading: loading,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    renderProductHeader(),
                    renderRow(
                        title: "Packing",
                        value: product != null ? product['PACKING'] : "",
                        icon: const ThemeIcon(
                            child: FaIcon(
                          FontAwesomeIcons.boxesPacking,
                          size: 30,
                        ))),
                    renderRow(
                        title: "With Brand",
                        value: product != null ? product['with_brand'] : "",
                        icon: const ThemeIcon(
                            child: FaIcon(
                          FontAwesomeIcons.brandsFontAwesome,
                          size: 30,
                        ))),
                    renderRow(
                        title: "Strength",
                        value: product != null ? product['STRENGTH'] : "",
                        icon: const ThemeIcon(
                            child: FaIcon(
                          FontAwesomeIcons.pagelines,
                          size: 30,
                        ))),
                    renderRow(
                        title: "Content",
                        value: product != null ? product['CONTENT'] : "",
                        icon: const ThemeIcon(
                            child: FaIcon(
                          FontAwesomeIcons.boxesStacked,
                          size: 30,
                        )),
                        onClick: () => {
                              Navigator.pushNamed(
                                  context, '/product-content', arguments: {
                                "content":
                                    product != null ? product['CONTENT'] : ""
                              })
                            }),
                    renderRow(
                        title: "Scheduled/Banned",
                        value: product != null ? product['SCHEDULE'] : "",
                        icon: const ThemeIcon(
                            child: FaIcon(
                          FontAwesomeIcons.businessTime,
                          size: 30,
                        ))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ThemeButton(
                          onClick: () => {
                            showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                useRootNavigator: true,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter
                                            setState /*You can rename this!*/) {
                                      return CustomBottomSheet(
                                          title: "Select Company",
                                          footer: Row(
                                            children: [
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: ThemeButton(
                                                  onClick: () =>
                                                      {onNextClick()},
                                                  text: "Next",
                                                ),
                                              )),
                                            ],
                                          ),
                                          child: AddCartCompanyList(
                                            company: product != null
                                                ? product['COM_FULL']
                                                    .split(" ")[0]
                                                : "",
                                            selectedItem: selectedCompany,
                                            onClick: (val) {
                                              setState(() {
                                                selectedCompany =
                                                    val['COMPANY_NAME'];
                                              });
                                            },
                                          ));
                                    },
                                  );
                                })
                          },
                          text: "Add To Cart",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
