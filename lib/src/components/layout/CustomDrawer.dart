import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/ui/ThemeIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/auth.dart';
import '../../api/profile.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  dynamic user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfile();
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

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                onTap: () => Navigator.pushNamed(context, '/home',
                    arguments: {"index": 1}),
                title: Text(
                  user != null &&
                          user['first_name'] != null &&
                          user['last_name'] != null
                      ? "${user['first_name']} ${user['last_name']}"
                      : "${user['firm_name']}",
                  style: themeData.textTheme.titleLarge,
                ),
                subtitle: Text(
                  user != null && user['city'] != null ? "${user['city']}" : "",
                  style: themeData.textTheme.titleSmall?.copyWith(fontSize: 10),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: themeData.primaryColor),
                  child: Text(
                      user != null && user['first_name'] != null
                          ? "${user['first_name'][0].toUpperCase()}"
                          : "${user['firm_name'][0].toUpperCase()}",
                      style: themeData.textTheme.titleLarge
                          ?.copyWith(fontSize: 25, color: Colors.white)),
                ),
              ),
              const Divider(
                height: 2,
              ),
              ListTile(
                title: const Text("Brand Search"),
                leading: const ThemeIcon(
                  child: Icon(Icons.branding_watermark),
                ),
                onTap: () =>
                    {Navigator.popAndPushNamed(context, '/brand-search')},
              ),
              ListTile(
                title: const Text("Company Search"),
                leading: const ThemeIcon(
                  child: Icon(Icons.home_filled),
                ),
                onTap: () =>
                    {Navigator.popAndPushNamed(context, '/company-search')},
              ),
              ListTile(
                title: const Text("Generic Search"),
                leading: const ThemeIcon(
                  child: Icon(Icons.medical_information_outlined),
                ),
                onTap: () =>
                    {Navigator.popAndPushNamed(context, '/generic-search')},
              ),
              ListTile(
                title: const Text("Company To Stockist"),
                leading: const ThemeIcon(
                  child: Icon(Icons.home_repair_service),
                ),
                onTap: () =>
                    {Navigator.popAndPushNamed(context, '/company-stockiest')},
              ),
              ListTile(
                title: const Text("Stockist To Company"),
                leading: const ThemeIcon(
                  child: Icon(Icons.store),
                ),
                onTap: () =>
                    {Navigator.popAndPushNamed(context, '/stockiest-company')},
              ),
              ListTile(
                title: const Text("Chemist & Druggist"),
                leading: const ThemeIcon(
                  child: Icon(Icons.medical_information),
                ),
                onTap: () =>
                    {Navigator.popAndPushNamed(context, '/chemist-drugist')},
              ),
              ListTile(
                title: const Text("Add Stockist"),
                leading: const ThemeIcon(
                  child: Icon(Icons.add),
                ),
                onTap: () =>
                    {Navigator.popAndPushNamed(context, '/add-stockiest')},
              ),
              ListTile(
                title: const Text("Add Product"),
                leading: const ThemeIcon(
                  child: Icon(Icons.add_comment_outlined),
                ),
                onTap: () =>
                    {Navigator.popAndPushNamed(context, '/add-product')},
              ),
              ListTile(
                title: const Text("My Orders"),
                leading: const ThemeIcon(
                  child: Icon(Icons.production_quantity_limits),
                ),
                onTap: () => {Navigator.popAndPushNamed(context, '/orders')},
              ),
              ListTile(
                title: const Text("My Cart"),
                leading: const ThemeIcon(
                  child: Icon(Icons.shopping_cart),
                ),
                onTap: () => {Navigator.popAndPushNamed(context, '/cart')},
              ),
              ListTile(
                title: const Text("Signout"),
                leading: const ThemeIcon(
                  child: Icon(Icons.power_off_outlined),
                ),
                onTap: () => removeToken(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
