import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medpocket/src/api/auth.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:medpocket/src/components/ui/ThemeIcon.dart';

import '../../api/profile.dart';
import '../../components/ui/CustomTextField.dart';

class AddStockiest extends StatefulWidget {
  const AddStockiest({Key? key}) : super(key: key);

  @override
  State<AddStockiest> createState() => _AddStockiestState();
}

class _AddStockiestState extends State<AddStockiest> {
  PlatformFile? file;
  dynamic user;
  final firmName = TextEditingController();
  final city = TextEditingController();
  final mobileNumber = TextEditingController();
  bool loading = false;
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
                // firmName.text = user['firm_name'] ?? "";
                // city.text = user['city'] ?? "";
                // mobileNumber.text = user['phone'].toString() ?? "";
              })
            }
        });
  }

  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        file = result.files.first;
        debugPrint("file $file");
      });
    }
  }

  getSelectedFiles() {
    final fileNew = file;
    if (fileNew != null) {
      return ListTile(
        leading: const ThemeIcon(
          child: Icon(Icons.file_copy_sharp),
        ),
        title: Text(fileNew.name),
        subtitle: Text(fileNew.size.toString()),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              file = null;
            });
          },
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: "Add Stockiest",
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: CustomTextField(
                  controller: firmName,
                  onChanged: () {},
                  validator: () {},
                  hint: "Firm Name",
                  // readOnly: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: CustomTextField(
                  controller: city,
                  onChanged: () {},
                  validator: () {},
                  hint: "City",
                  // readOnly: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: CustomTextField(
                  controller: mobileNumber,
                  onChanged: () {},
                  validator: () {},
                  hint: "Mobile Number",
                  // readOnly: true,
                ),
              ),
              Expanded(
                flex: 0,
                child: InkWell(
                  onTap: picksinglefile,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffdddddd),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    child: DottedBorder(
                      borderPadding: EdgeInsets.all(10),
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      dashPattern: [8, 4],
                      strokeWidth: 2,
                      color: Colors.black38,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ThemeIcon(
                                child: Icon(
                                  Icons.upload_file_rounded,
                                  size: 50,
                                ),
                              ),
                              Text(
                                "Click here to upload file",
                                style: themeData.textTheme.titleLarge?.copyWith(
                                    color: themeData.primaryColorDark),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: getSelectedFiles(),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: ThemeButton(
                    loading: loading,
                    onClick: () async {
                      if (file == null) {
                        Fluttertoast.showToast(
                            msg: "Please select file",
                            toastLength: Toast.LENGTH_LONG);
                      } else {
                        setState(() {
                          loading = true;
                        });
                        final data = {
                          "firm_name": firmName.text,
                          "center": city.text,
                          "phone": mobileNumber.text,
                        };
                        addStockiest(data, file).then((value) => {
                              setState(() {
                                loading = false;
                              }),
                              debugPrint("value $value"),
                              if (value['status'] == 1)
                                {
                                  setState(() {
                                    file = null;
                                    firmName.text = "";
                                    city.text = "";
                                    mobileNumber.text = "";
                                  }),
                                  Fluttertoast.showToast(
                                      msg: "Stockiest Added",
                                      toastLength: Toast.LENGTH_LONG)
                                }
                            });
                      }
                    },
                    text: "Save",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
