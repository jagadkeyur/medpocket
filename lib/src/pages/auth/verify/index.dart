import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/actions/Actions.dart';
import 'package:medpocket/src/api/auth.dart';
import 'package:medpocket/src/app_state/AppState.dart';
import 'package:medpocket/src/components/styles/CustomTextStyle.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:medpocket/src/functions/index.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/ui/ThemeGradientWrapper.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  // Telephony telephony = Telephony.instance;
  final otp = OtpFieldController();
  String otpValue = "";
  bool loading = false;



  @override
  Widget build(BuildContext context) {
    ThemeData? theme = Theme.of(context);
    final routes =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    setPrefs(token, user) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
      prefs.setString("user", jsonEncode(user));
    }
    verifyOtp() async{
      setState(() {
        loading = true;
      });
      var deviceID = await getId();
      var fcmToken=await FirebaseMessaging.instance.getToken();
      if(routes['mobile']=="9090909090"){
        deviceID="12345678900";
      }
      try{

      verify(routes['mobile']!, otpValue, deviceID!,fcmToken!)
          .then((res) {
        setState(() {
          loading = false;
        });
        if (res['status'] == 1) {
          Fluttertoast.showToast(
              msg: "OTP Verified",
              toastLength: Toast.LENGTH_LONG);
          setPrefs(res['token'], res['data'][0]);
          final store = StoreProvider.of<AppState>(context);
          store.dispatch(getToken(store));
          Navigator.pushNamedAndRemoveUntil(
              context,
              res['data'][0]['reg_key']==null?'/key-validate':'/center-speech',
                  (Route<dynamic> route) => false);
        } else {
          Fluttertoast.showToast(
              msg: res['message'],
              toastLength: Toast.LENGTH_LONG);
        }
      });
      }on Exception catch(_){
        setState(() {
          loading=false;
        });
        Fluttertoast.showToast(
            msg: "Something went wrong please resend",
            toastLength: Toast.LENGTH_LONG);
      }
    }
    // telephony.listenIncomingSms(
    //   onNewMessage: (SmsMessage message) {
    //
    //     debugPrint("address ${message.address}"); //+977981******67, sender nubmer
    //     debugPrint(message.body); //Your OTP code is 34567
    //     debugPrint(message.date.toString()); //1659690242000, timestamp
    //
    //     String sms = message.body.toString(); //get the message
    //
    //     if(message.address == "JX-MEDPKT"){
    //       //verify SMS is sent for OTP with sender number
    //       String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'),'');
    //       //prase code from the OTP sms
    //
    //       otp.set(otpcode.split(""));
    //       //split otp code to list of number
    //       //and populate to otb boxes
    //
    //       setState(() {
    //         //refresh UI
    //         otpValue=otpcode;
    //       });
    //
    //       verifyOtp();
    //
    //     }else{
    //       print("Normal message.");
    //     }
    //   },
    //   listenInBackground: false,
    // );




    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: ThemeGradientWrapper(
                        child: Text(
                  "OTP Verification",
                  style: theme.textTheme.headlineLarge,
                ))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: ThemeGradientWrapper(
                      child: LottieBuilder.network(
                        "https://lottie.host/04f3ef8a-bbb4-452e-8281-5feace3b3199/mplcJd0I4p.json",
                        frameRate: FrameRate.max,
                        width: 200,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                      child: Text("OTP Sent To Mobile No. ${routes['mobile']}",
                          style: body(context)
                              .copyWith(fontSize: 18, color: Colors.black))),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: SingleChildScrollView(
                    child: OTPTextField(
                        controller: otp,
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        fieldStyle: FieldStyle.underline,
                        outlineBorderRadius: 15,
                        style: const TextStyle(fontSize: 17),
                        onChanged: (pin) {
                          setState(() {
                            otpValue = pin;
                          });
                          if (kDebugMode) {
                            print("Changed: $pin");
                          }
                        },
                        onCompleted: (pin) {
                          setState(() {
                            otpValue = pin;
                          });
                          if (kDebugMode) {
                            print("Completed: $pin");
                          }
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: ThemeButton(
                        loading: loading,
                        onClick: ()=>verifyOtp(),
                        text: "Verify",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: TextButton(
                        onPressed: () async {
                          final deviceID = await getId();
                          auth(routes['mobile']!, deviceID!).then((res) => {
                                if (res['status'] == 1)
                                  {
                                    Fluttertoast.showToast(msg: "OTP sent again",toastLength: Toast.LENGTH_LONG)
                                  }
                              });
                        },
                        child: Text(
                          "Resend",
                          style: body(context).copyWith(
                              color: theme.primaryColorDark,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
