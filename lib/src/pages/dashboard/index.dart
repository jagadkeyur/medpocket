import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/CircleWrapper.dart';
import 'package:medpocket/src/components/layout/DashboardTile.dart';

import '../../api/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  dynamic user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfile();
  }
  getUserProfile(){
    getProfile().then((value) => {
      if (value['status'] == 1)
        {
          setState(() {
            user = value['data'];
          })
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget renderReceivedOrders(){
      if(user!=null && user['is_stockiest']==1){
        return DashboardTile(
            index:9,
            icon: const Icon(
              Icons.production_quantity_limits,
              size: 50,
            ),
            label: "Received Orders",
            onClick: () {Navigator.pushNamed(context, '/orders',arguments: {"is_received":1});});
      }else{
        return const SizedBox(width: 0,height: 0,);
      }
    }
    List<Widget> dashboardLinks = [
      DashboardTile(
        index:1,
          icon: const Icon(
            Icons.branding_watermark,
            size: 50,
          ),
          label: "Brand Search",
          onClick: () {
            Navigator.pushNamed(context, '/brand-search');
          }),
      DashboardTile(
        index:2,
          icon: const Icon(
            Icons.home_filled,
            size: 50,
          ),
          label: "Company Search",
          onClick: () {
            Navigator.pushNamed(context, '/company-search');
          }),
      DashboardTile(
        index:3,
          icon: Icon(
            Icons.medical_information_outlined,
            size: 50,
          ),
          label: "Generic Search",
          onClick: () {
            Navigator.pushNamed(context, '/generic-search');
          }),
      DashboardTile(
        index:4,
          icon: Icon(
            Icons.home_repair_service,
            size: 50,
          ),
          label: "Company To Stockist",
          onClick: () {
            Navigator.pushNamed(context, '/company-stockiest');
          }),
      DashboardTile(
        index:5,
          icon: Icon(
            Icons.store,
            size: 50,
          ),
          label: "Stockist To Company",
    onClick: () {
    Navigator.pushNamed(context, '/stockiest-company');
    }),
      DashboardTile(
        index:6,
          icon: Icon(
            Icons.medical_information,
            size: 50,
          ),
          label: "Chemist & Druggist",
          onClick: () {
            Navigator.pushNamed(context, '/chemist-drugist');
          }),
      DashboardTile(
        index:7,
          icon: Icon(
            Icons.add,
            size: 50,
          ),
          label: "Add Stockist",
          onClick: () {Navigator.pushNamed(context, '/add-stockiest');}),
      DashboardTile(
        index:8,
          icon: Icon(
            Icons.add_comment_outlined,
            size: 50,
          ),
          label: "Add Product",
          onClick: () {Navigator.pushNamed(context, '/add-product');}),
      DashboardTile(
        index:9,
          icon: Icon(
            Icons.production_quantity_limits,
            size: 50,
          ),
          label: "My Orders",
          onClick: () {Navigator.pushNamed(context, '/orders');}),
      DashboardTile(
        index:10,
          icon: Icon(
            Icons.shopping_cart,
            size: 50,
          ),
          label: "My Cart",
          onClick: () {Navigator.pushNamed(context, '/cart');}),
      renderReceivedOrders()
    ];
    return GridView.count(
      padding: EdgeInsets.only(left: 20,top: 20,right: 20,bottom: 120),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: dashboardLinks,
    );
  }
}
