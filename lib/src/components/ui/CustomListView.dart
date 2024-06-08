import 'package:flutter/material.dart';
import 'package:medpocket/src/components/layout/NoData.dart';

class CustomListView extends StatefulWidget {
  final Widget child;
  final bool hasData;
  const CustomListView({super.key, required this.child, required this.hasData});

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    if (widget.hasData) {
      return widget.child;
    } else {
      return NoData();
    }
  }
}
