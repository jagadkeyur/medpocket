import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/product_list_page/add_cart_srockiest_list.dart';
import '../ui/ThemeButton.dart';

class CustomBottomSheet extends StatefulWidget {
  final String title;
  final Widget child;
  Widget footer=Container();
  CustomBottomSheet({Key? key,this.title="",required this.child,required this.footer}) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return SizedBox(
            // height: MediaQuery.of(
            //             context)
            //         .size
            //         .height /
            //     1.3,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [themeData.primaryColor,Colors.white],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter
                      // )
                      // color: Colors.black12,

                    ),

                    child: Padding(
                      padding:
                      EdgeInsets
                          .symmetric(
                          horizontal: 20,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: themeData
                                .textTheme
                                .titleLarge,
                          ),
                          IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child:widget.child,
                  ),
                  widget.footer
                ],
              ));

  }
}
