// ignore_for_file: library_private_types_in_public_api

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:medpocket/src/components/styles/CustomTextStyle.dart';

class CustomDropDown extends StatefulWidget {
  final String hint;
  final String modalTitle;
  final String defaultValue;
  final Color baseColor;
  final Color borderColor;
  final Color errorColor;
  final Function validator;
  final Function(String?) onChanged;
  final List<String> items;

  const CustomDropDown(
      {super.key,
      this.hint = "",
      this.modalTitle = "Select",
      this.defaultValue = "",
      required this.items,
      required this.onChanged,
      required this.baseColor,
      required this.borderColor,
      required this.errorColor,
      required this.validator});

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData? theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            widget.hint,
            style:
                theme.textTheme.bodyLarge?.copyWith(color: theme.primaryColor),
          ),
        ),
        PhysicalModel(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          elevation: 3.0,
          shadowColor: Colors.primaries.last,
          child: DropdownSearch<String>(
            items: widget.items,
            onChanged: widget.onChanged,
            selectedItem: widget.defaultValue,
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15))),
            dropdownButtonProps: DropdownButtonProps(
              color: theme.primaryColor,
            ),
            popupProps: PopupProps.modalBottomSheet(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    widget.modalTitle,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.primaryColor),
                  )),
                ),
                showSearchBox: true,
                listViewProps: ListViewProps(
                  padding: EdgeInsets.symmetric(horizontal: 15)
                ),
                searchFieldProps: TextFieldProps(autofocus: true,padding: EdgeInsets.symmetric(horizontal: 20),decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  hintText: "Search ${widget.hint}"
                ))),
          ),
        ),
      ],
    );
  }
}
