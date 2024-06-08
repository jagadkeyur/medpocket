
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/api/auth.dart';
import 'package:medpocket/src/components/styles/CustomTextStyle.dart';
import 'package:medpocket/src/components/ui/CustomTextField.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:medpocket/src/components/ui/ThemeGradientWrapper.dart';

import '../../../functions/index.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final mobileNumber = TextEditingController();
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    ThemeData? theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0,bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: ThemeGradientWrapper(child: Text("Sign in",style: theme.textTheme.headlineLarge,))),
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
                //   child: Text("Signin", style: h1(context)),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: ThemeButton(
                        loading: loading,
                        onClick: () async{
                          setState(() {
                            loading = true;
                          });
                          var deviceID=await getId();
                          if(mobileNumber.text=="9090909090"){
                            deviceID="12345678900";
                          }
                          debugPrint("device id $deviceID");
                          auth(mobileNumber.text,deviceID!).then((value) {
                            setState(() {
                              loading = false;
                            });
                            if (value['status'] == 1) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/verify', (Route<dynamic> route) => false,
                                  arguments: {"mobile": mobileNumber.text});
                            }else{
                              Fluttertoast.showToast(msg: value['message'],toastLength: Toast.LENGTH_LONG);
                            }
                          });
                        },
                        text: "Sign in",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: const Text("Forgot"),
                                    content: const Text("Forgot Password"),
                                    actions: [
                                      ThemeButton(
                                          onClick: () =>
                                              Navigator.pop(context, false),
                                          text: "OK")
                                    ],
                                  )).then((exit) {
                            return false;
                          });
                        },
                        child: Text(
                          "Forgot Password?",
                          style: body(context).copyWith(
                              color: theme.primaryColorDark,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: theme.textTheme.titleMedium,
                              children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: theme.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/signup');
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
