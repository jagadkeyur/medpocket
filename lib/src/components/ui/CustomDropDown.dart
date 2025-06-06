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
  final bool enabled;

  const CustomDropDown({
    super.key,
    this.hint = "",
    this.modalTitle = "Select",
    this.defaultValue = "",
    this.enabled = true,
    required this.items,
    required this.onChanged,
    required this.baseColor,
    required this.borderColor,
    required this.errorColor,
    required this.validator,
  });

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
        Material(
          // Wrap with Material widget
          color: Colors
              .white, // Make sure it's transparent so we maintain the original design
          borderRadius: BorderRadius.circular(8),
          elevation: 3.0,
          shadowColor: Colors.primaries.last,
          child: DropdownSearch<String>(
            enabled: widget.enabled,
            selectedItem: widget.defaultValue,
            onChanged: widget.onChanged,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),
            popupProps: PopupProps.modalBottomSheet(
              showSearchBox: true,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    widget.modalTitle,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.primaryColor),
                  ),
                ),
              ),
              listViewProps: ListViewProps(
                padding: EdgeInsets.symmetric(horizontal: 15),
              ),
              searchFieldProps: TextFieldProps(
                autofocus: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  hintText: "Search ${widget.hint}",
                ),
              ),
            ),
            asyncItems: (String? filter) async {
              return widget.items
                  .where((item) =>
                      filter == null ||
                      item.toLowerCase().contains(filter.toLowerCase()))
                  .toList();
            },
          ),
        ),
      ],
    );
  }
}
