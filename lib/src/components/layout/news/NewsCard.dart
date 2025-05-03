import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/CardWrapper.dart';
import 'package:medpocket/src/components/ui/ThemeIcon.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsCard extends StatefulWidget {
  final dynamic item;
  const NewsCard({Key? key, required this.item}) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Material(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/news-details',
              arguments: {"news": widget.item});
        },
        child: CardWrapper(
          // elevation: 3,
          // margin: EdgeInsets.only(left: 15,bottom: 15,right: 15),
          child: ListTile(
            title: Text(
              widget.item['messageHeader'],
              style: themeData.textTheme.titleMedium,
            ),
            leading: const ThemeIcon(
              child: Icon(
                Icons.newspaper,
                size: 30,
              ),
            ),
            trailing: Text(
              timeago.format(DateTime.parse(widget.item['msgTime'])),
              style: themeData.textTheme.bodySmall
                  ?.copyWith(color: Colors.black38),
            ),
          ),
        ),
      ),
    );
  }
}
