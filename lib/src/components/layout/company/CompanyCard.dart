import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';

class CompanyCard extends StatelessWidget {
  final dynamic item;
  const CompanyCard({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () => {
        Navigator.pushNamed(context, '/brand-search',
            arguments: {"company": item})
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
          title: Text(item['COMPANY']),
          subtitle: Text(item['COM_FULL']),
          dense: true,
        ),
      ),
    );
  }
}
