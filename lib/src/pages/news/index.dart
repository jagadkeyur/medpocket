import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medpocket/src/api/news.dart';
import 'package:medpocket/src/components/layout/PageLoader.dart';
import 'package:medpocket/src/components/layout/news/NewsCard.dart';
import 'package:medpocket/src/components/ui/CustomListView.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  dynamic newsList = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsList();
  }

  getNewsList() {
    setState(() {
      loading = true;
    });
    getNews().then((value) => {
          if (value['status'] == 1)
            {
              setState(() {
                loading = false;
                newsList = value['data'];
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageLoader(
      loading: loading,
      child: RefreshIndicator(
        onRefresh: () => getNewsList(),
        child: CustomListView(
          hasData: newsList.length > 0 ? true : false,
          child: ListView.builder(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
              itemCount: newsList.length,
              addRepaintBoundaries: true,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return NewsCard(
                  item: newsList[index],
                );
              }),
        ),
      ),
    )
        .animate()
        .slideY(duration: 500.ms, begin: 1, end: 0, curve: Curves.easeInOut);
  }
}
