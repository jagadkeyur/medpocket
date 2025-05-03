import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:medpocket/src/components/layout/qr_overlay.dart';
import 'package:medpocket/src/components/styles/CustomTextStyle.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/auth.dart';
import '../../../components/ui/CustomTextField.dart';
import '../../../components/ui/ThemeGradientWrapper.dart';

class KeyValidation extends StatefulWidget {
  const KeyValidation({super.key});

  @override
  State<KeyValidation> createState() => _KeyValidationState();
}

class _KeyValidationState extends State<KeyValidation> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  MobileScannerController? controller;
  final keyValidator = TextEditingController();
  String otpValue = "";
  bool loading = false;

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        print('muere');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    didChangeAppLifecycleState(AppLifecycleState.detached);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData? theme = Theme.of(context);
    // var maskFormatter = new (
    //     mask: '+# (###) ###-##-##',
    //     filter: { "#": RegExp(r'[0-9]') },
    //     type: MaskAutoCompletionType.lazy
    // );

    setPrefs(token, user) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
      prefs.setString("user", jsonEncode(user));
    }

    Widget qrScanner() {
      return MobileScanner(
        controller: controller,
        // overlay: QRScannerOverlay(
        //   overlayColour: Colors.black45,
        // ),
        // fit: BoxFit.contain,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            if (barcode.rawValue != '') {
              debugPrint('Barcode found! ${barcode.rawValue}');
              keyValidator.text = barcode.rawValue ?? "";
              controller?.dispose();
              controller?.stop();
              Future.delayed(Duration.zero, () => {Navigator.pop(context)});
            }
          }
        },
      );
    }
    // Widget qrScanner() {
    //   void onQRViewCreated(QRViewController controller) {
    //     this.controller = controller;
    //     controller.scannedDataStream.listen((scanData,) {
    //       keyValidator.text = scanData.code ?? "";
    //       Navigator.pop(context);
    //     }).onError((error)=>Fluttertoast.showToast(msg: error));
    //     controller.pauseCamera();
    //     controller.resumeCamera();
    //   }
    //
    //   return QRView(
    //     key: qrKey,
    //     onQRViewCreated: onQRViewCreated,
    //     overlay:
    //         QrScannerOverlayShape(overlayColor: Colors.white.withOpacity(0.5)),
    //   );
    // }

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
                  "Key Validator",
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
                      child: Text(
                          "Please enter registration key provided to verify your account",
                          style: body(context)
                              .copyWith(fontSize: 18, color: Colors.black))),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomTextField(
                          baseColor: Colors.grey,
                          borderColor: Colors.grey,
                          errorColor: Colors.red,
                          controller: keyValidator,
                          hint: "Registration Key",
                          // inputType: TextInputType.,
                          validator: () => {},
                          onChanged: () => {},
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter
                                              setState /*You can rename this!*/) {
                                        return qrScanner();
                                      },
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.qr_code_2,
                              size: 45,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: ThemeButton(
                    loading: loading,
                    onClick: () async {
                      setState(() {
                        loading = true;
                      });
                      validateRegKey(keyValidator.text).then((res) => {
                            setState(() {
                              loading = false;
                            }),
                            if (res['status'] == 1)
                              {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/center-speech',
                                  (Route<dynamic> route) => false,
                                )
                              },
                            Fluttertoast.showToast(
                                msg: res['message'],
                                toastLength: Toast.LENGTH_LONG)
                          });
                    },
                    text: "Validate",
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
