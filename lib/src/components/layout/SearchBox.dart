import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SearchBox extends StatefulWidget {
  StreamController<String> streamController = StreamController();
  String? defaultValue;
  TextEditingController? textEditingController;
  SearchBox(
      {Key? key,
      required this.streamController,
      this.defaultValue,
      this.textEditingController})
      : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    // final searchText=TextEditingController();
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: GradientBoxBorder(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  stops: const [0, 0.5],
                  colors: [themeData.primaryColor, themeData.primaryColorDark]),
              width: 1,
            )),
        child: CupertinoSearchTextField(
          controller: widget.textEditingController,
          autofocus: true,
          autocorrect: true,
          // controller: searchText,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(20),
          onChanged: (query) => {widget.streamController.add(query)},
        ),
      ),
    );
  }
}
