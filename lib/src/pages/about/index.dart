import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        child: Column(
          children: [
            Text(
              "COMMITED TO PHARMA INDUSTRY - MEDISOFT SERVICES",
              style: themeData.textTheme.headlineSmall
                  ?.copyWith(color: themeData.primaryColor),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                "Welcome to the family of Medisoft services. We made a very humble beginning in the year 1999 in Rajkot the capital of saurashtra(Gujarat). Our buisness grew by leaps and bounds to help us start a publishing company which has reached a coveted postion in todays market.",
                style: themeData.textTheme.bodyLarge,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                "Medisoft Services started to publish a pharmaceutical journal superior products and the combination of clever advertising and purposeful marketing soon ensured that Medisoft Services became a household name in pharmaceutical field. Over the years, Medisoft Services has strengthened its reputation for the intelligent and pioneering application of technologies.",
                style: themeData.textTheme.bodyLarge,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                "We started with very few titles but now with perseverance and dedication of staff, we have grown to become largest circulated pharma trade journal named India Mediguide (IMG) in Gujarat. We are continuing out journey with hard work and devotion to become the prenmiere company - supplying rewarding knowledge of medical science duly updated to the chemist and druggists, medical practitioners and upcoming students in the pharma/medical field.",
                style: themeData.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .slideY(duration: 500.ms, begin: 1, end: 0, curve: Curves.easeInOut);
  }
}
