import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/api/product.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';

import '../../components/layout/AppBar.dart';
import '../../components/layout/PageLoader.dart';

class ContentDetails extends StatefulWidget {
  final String content;
  const ContentDetails({Key? key,this.content=""}) : super(key: key);

  @override
  State<ContentDetails> createState() => _ContentDetailsState();
}

class _ContentDetailsState extends State<ContentDetails> {
  late dynamic args = null;
  late dynamic content = null;
  bool loading = false;
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        loading=true;
        args = ModalRoute.of(context)?.settings.arguments;
      });

      if (args != null) {
        if (args['content'] != null) {
          productByContent(args['content']).then((value) => {
            setState(() {
              loading=false;
              content = value['data'];
            })
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    renderRow({title="",content="",active=false}){
      return CardWrapper(
        child: ExpansionTile(
          title: Text(title),
          initiallyExpanded: active,
          childrenPadding: EdgeInsets.only(left: 15,right: 15,bottom: 15),
          collapsedIconColor: themeData.primaryColor,
          expandedAlignment: Alignment.topLeft,
          children: [
          Text(content=="" ? "N/A":content,style: themeData.textTheme.bodyMedium,)
        ],),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CustomAppBar(
        title: "Content Detail",
      ),
      body: PageLoader(
        loading: loading,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
          child: SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      renderRow(
                        title: "DOSAGE AND INDICATION",
                        content: content!=null?content['dosage'] : "",
                        active: true
                      ),
                      renderRow(
                          title: "CONTRAINDICATION",
                          content: content!=null?content['CONTRAINDICATION'] : "",
                      ),
                      renderRow(
                          title: "ADVERCE DRUG REACTION",
                          content: content!=null?content['ADVERSE_DRUG_REACTION'] : "",
                      ),
                      renderRow(
                          title: "SPECIAL PRECAUTION",
                          content: content!=null?content['SPECIAL_PRECAUTIONS'] : "",
                      ),
                      renderRow(
                          title: "PREGNANCY CATEGORY",
                          content: content!=null?content['PREGNANCY_CTG'] : "",
                      ),
                      renderRow(
                          title: "LACTATION",
                          content: content!=null?content['LACTATION'] : "",
                      ),
                      renderRow(
                          title: "INTERACTION",
                          content: content!=null?content['INTERACTION'] : "",
                      ),
                    ],
                  ),

                  //
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
