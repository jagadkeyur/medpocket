import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medpocket/src/api/auth.dart';
import 'package:medpocket/src/components/layout/AppBar.dart';
import 'package:medpocket/src/components/ui/ThemeButton.dart';
import 'package:medpocket/src/components/ui/ThemeIcon.dart';

import '../../api/profile.dart';
import '../../components/ui/CustomTextField.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  PlatformFile? file;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: "Add Product",
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(flex: 0,child: Container(padding: EdgeInsets.all(15), child: Text("Please upload product file like excel,pdf or image admin will approve and live your products after verification",textAlign: TextAlign.center,style: themeData.textTheme.titleLarge,)),),
            Expanded(
              flex: 1,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ThemeIcon(
                              child: Icon(
                                Icons.upload_file_rounded,
                                size: 80,
                              ),
                            ),
                            Text(
                              "Click here to upload file",
                              style: themeData.textTheme.titleLarge
                                  ?.copyWith(color: themeData.primaryColorDark),
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
                  onClick: ()async {
                    setState(() {
                      loading=true;
                    });
                    if(file==null){
                      Fluttertoast.showToast(msg: "Please select file",toastLength: Toast.LENGTH_LONG);
                      setState(() {
                        loading=false;
                      });
                    }else{
                    addProduct(file).then((value) => {
                      setState(() {
                        loading=false;
                      }),
                      debugPrint("value $value"),
                      if(value['status']==1){
                        setState((){
                          file=null;
                        }),
                        Fluttertoast.showToast(msg: "Product Added",toastLength: Toast.LENGTH_LONG)
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
    );
  }
}
