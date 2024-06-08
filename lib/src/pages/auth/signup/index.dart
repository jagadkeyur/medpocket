import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/api/auth.dart';
import 'package:medpocket/src/components/styles/CustomTextStyle.dart';
import 'package:medpocket/src/components/ui/CustomTextField.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:medpocket/src/functions/index.dart';
import 'package:uuid/uuid.dart';

import '../../../components/ui/CustomDropDown.dart';
import '../../../components/ui/ThemeGradientWrapper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final mobileNumber = TextEditingController();
  final firmName = TextEditingController();
  String center = "";
  bool loading = false;
  late String? deviceId = "";
  List<String> centers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    ThemeData? theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: ThemeGradientWrapper(child: Text("Sign up",style: theme.textTheme.headlineLarge,))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                child: ThemeGradientWrapper(
                child: LottieBuilder.network(
                  "https://lottie.host/04f3ef8a-bbb4-452e-8281-5feace3b3199/mplcJd0I4p.json",
                  frameRate: FrameRate.max,
                  width: 200,
                ),
                      )),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 20.0),
                //   child: Text("Signup", style: h1(context)),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CustomTextField(
                    baseColor: Colors.grey,
                    borderColor: Colors.grey,
                    errorColor: Colors.red,
                    controller: firmName,
                    hint: "Firm Name",
                    inputType: TextInputType.text,
                    validator: () => {},
                    onChanged: () => {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CustomTextField(
                    baseColor: Colors.grey,
                    borderColor: Colors.grey,
                    errorColor: Colors.red,
                    controller: mobileNumber,
                    hint: "Mobile Number",
                    inputType: TextInputType.phone,
                    validator: () => {},
                    onChanged: () => {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CustomDropDown(
                    hint: "Center",
                    items: centers,
                    onChanged: ((val) => setState(() => {center = val ?? ""})),
                    baseColor: Colors.grey,
                    borderColor: Colors.grey,
                    errorColor: Colors.red,
                    validator: () => {},
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: ThemeButton(
                          loading: loading,
                          onClick: () async {
                            setState(() {
                              loading = true;
                            });
                            final deviceID=await getId();
                            final data={
                              "firm_name":firmName.text,
                              "phone":mobileNumber.text,
                              "city":center,
                              "uuid":const Uuid().v1().toString(),
                              "device_id":deviceID
                            };
                            signup(data).then((value) {
                              setState(() {
                                loading = false;
                              });
                              if (value['status'] == 1) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/verify', (Route<dynamic> route) => false,
                                    arguments: {"mobile": mobileNumber.text});
                              }
                            });
                          },
                          text: "Sign up",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Already have an account? ",
                              style: theme.textTheme.titleMedium,
                              children: [
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(
                                color: theme.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/signin');
                                },
                            )
                          ]))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
