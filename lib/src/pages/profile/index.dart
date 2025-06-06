import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medpocket/src/actions/RestartWidget.dart';
import 'package:medpocket/src/api/auth.dart';
import 'package:medpocket/src/api/profile.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/ui/CustomDropDown.dart';
import 'package:medpocket/src/components/ui/CustomTextField.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  dynamic user;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final firmName = TextEditingController();
  final city = TextEditingController();
  final mobileNumber = TextEditingController();
  dynamic jwt;
  final totalField = 6;
  int compeletedField = 0;
  double progress = 0;
  bool buttonLoading = false;
  bool buttonLoadingStockiest = false;
  bool loading = false;
  String center = "";
  String token = "";
  List<String> centers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfile();

    List<dynamic> data = [];
    List<String> newData = [];
    getCenters().then((value) => {
          data = value['data'],
          print(data),
          setState(() => {
                centers = data.map(
                  (item) {
                    return (item['center'] as String).toUpperCase();
                  },
                ).toList()
              })
        });
  }

  getUserProfile() {
    setState(() {
      loading = true;
    });
    getProfile().then((value) => {
          if (value['status'] == 1)
            {
              setState(() {
                loading = false;
                compeletedField = 0;
                user = value['data'];
                firstName.text = user['first_name'] ?? "";
                lastName.text = user['last_name'] ?? "";
                email.text = user['email'] ?? "";
                firmName.text = user['firm_name'] ?? "";
                center = user['city'] ?? "";
                mobileNumber.text = user['phone'].toString() ?? "";
                if (user['first_name'] != null || user['first_name'] != "")
                  compeletedField += 1;
                if (user['last_name'] != null || user['last_name'] != "")
                  compeletedField += 1;
                if (user['email'] != null || user['email'] != "")
                  compeletedField += 1;
                if (user['firm_name'] != null || user['firm_name'] != "")
                  compeletedField += 1;
                if (user['city'] != null || user['city'] != "")
                  compeletedField += 1;
                if (user['phone'] != null || user['phone'] != "")
                  compeletedField += 1;
                debugPrint("completed $compeletedField");
                progress = ((compeletedField * 100) / totalField);
              })
            }
        });
  }

  setPrefs(token, user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    prefs.setString("user", jsonEncode(user));
  }

  updateUserProfile() {
    setState(() {
      buttonLoading = true;
    });
    final data = {
      "first_name": firstName.text,
      "last_name": lastName.text,
      "email": email.text,
      "firm_name": firmName.text,
      "city": center ?? "",
      "phone": mobileNumber.text,
    };
    updateProfile(data).then((value) => {
          setState(() {
            buttonLoading = false;
          }),
          Fluttertoast.showToast(
              msg: "Profile Updated", toastLength: Toast.LENGTH_LONG),
          // if (value['status'] == 1)
          //   {
          //     // jwt = JWT(value['data']),
          //     // token = jwt.sign(SecretKey('medpocket@2022')),
          //     // setPrefs(token, value['data']),
          //     // Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false)
          //   }
        });
  }

  requestStockiest() {
    setState(() {
      buttonLoadingStockiest = true;
    });
    final data = {"stockiest_requested": "1"};

    updateProfile(data).then((value) => {
          setState(() {
            buttonLoadingStockiest = false;
          }),
          Fluttertoast.showToast(
              msg: "Stockiest Requested", toastLength: Toast.LENGTH_LONG),
          if (value['status'] == 1) getUserProfile()
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // if (user == null) return Container();
    return PageLoader(
      loading: loading,
      child: user != null
          ? Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              themeData.primaryColor,
                              themeData.primaryColorDark
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(10, 0))
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 0,
                            child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Center(
                                        child: Text(
                                      "${progress.toStringAsFixed(0)}%",
                                      style: themeData.textTheme.bodyLarge
                                          ?.copyWith(color: Colors.white),
                                    )),
                                    CircularProgressIndicator(
                                      value: progress / 100,
                                      strokeWidth: 10,
                                      color: Colors.white,
                                      backgroundColor: Colors.white30,
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi, ${user['firm_name'] ?? ""}",
                                  style: themeData.textTheme.bodyLarge
                                      ?.copyWith(
                                          color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomTextField(
                                      controller: firstName,
                                      onChanged: () {},
                                      validator: () {},
                                      hint: "First Name",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomTextField(
                                      controller: lastName,
                                      onChanged: () {},
                                      validator: () {},
                                      hint: "Last Name",
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                controller: email,
                                onChanged: () {},
                                validator: () {},
                                hint: "Email",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                controller: firmName,
                                onChanged: () {},
                                validator: () {},
                                hint: "Firm Name",
                                readOnly: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: CustomDropDown(
                                hint: "Center",
                                items: centers,
                                onChanged: ((val) =>
                                    setState(() => {center = val ?? ""})),
                                baseColor: Colors.grey,
                                borderColor: Colors.grey,
                                errorColor: Colors.red,
                                validator: () => {},
                                defaultValue: center,
                                enabled: false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                controller: mobileNumber,
                                onChanged: () {},
                                validator: () {},
                                hint: "Mobile Number",
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 0,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: ThemeButton(
                                onClick: () {
                                  updateUserProfile();
                                },
                                text: "Save",
                                loading: buttonLoading,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: ThemeButton(
                                onClick: () {
                                  if (user['stockiest_requested'] == 0 &&
                                      user['is_stockiest'] == 0) {
                                    requestStockiest();
                                  }
                                },
                                text: user != null &&
                                        user['stockiest_requested'] == 1
                                    ? "Requested Stockiest"
                                    : user != null && user['is_stockiest'] == 1
                                        ? "Already Verified"
                                        : "Verify Stockiest",
                                loading: buttonLoadingStockiest,
                                disabled: user['stockiest_requested'] == 1 ||
                                    user['is_stockiest'] == 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(),
    )
        .animate()
        .slideY(duration: 500.ms, begin: 1, end: 0, curve: Curves.easeInOut);
  }
}
