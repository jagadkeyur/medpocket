import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';

class CompanyStockiestCard extends StatelessWidget {
  final dynamic item;
  final dynamic args;
  const CompanyStockiestCard({Key? key, this.item,this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () => {
        if(args!=null && ((args!=null && args['stockiest']!=null) || (args!=null && args['firmName']!=null))){
          Navigator.pushNamed(context, '/stockiest-details',
              arguments: {"stockiest": item['FIRM_NAME']})
        }else{
        Navigator.pushNamed(context, '/stockiest-company',
            arguments: {"companyName": item['COMPANY_NAME']})
        }
      },
      child: CardWrapper(
        // elevation: 3,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(200)
        // ),
        child: ListTile(
          leading: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
                colors: [
                  themeData.primaryColor,
                  themeData.primaryColorDark,
                ],
              ).createShader(bounds),
              child: Icon(
                Icons.business,
                size: 40,
              )),
          title: Text(item['COMPANY_NAME']),
          // subtitle: Text(item['Strength']),
          dense: true,
        ),
      ),
    );
  }
}
