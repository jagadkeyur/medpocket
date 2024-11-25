// ignore_for_file: library_private_types_in_public_api

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medpocket/src/components/styles/CustomTextStyle.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color borderColor;
  final Color errorColor;
  final TextInputType inputType;
  final bool obscureText;
  final bool readOnly;
  final Function validator;
  final Function onChanged;
  final List<TextInputFormatter> inputFormatters;

  const CustomTextField(
      {super.key,
      this.hint = "",
      required this.controller,
      required this.onChanged,
      this.baseColor = Colors.grey,
      this.borderColor = Colors.grey,
      this.errorColor = Colors.red,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.readOnly = false,
      this.inputFormatters = const [],
      required this.validator});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.hint,
            style: themeData.textTheme.titleMedium
                ?.copyWith(color: themeData.primaryColor),
          ),
        ),
        PhysicalModel(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          elevation: 3.0,
          shadowColor: Colors.primaries.last,
          child: TextField(
            obscureText: widget.obscureText,

            // onChanged: (text) {
            //   // widget.onChanged(text);
            //   setState(() {
            //     if (!widget.validator(text) || text.isEmpty) {
            //       currentColor = widget.errorColor;
            //     } else {
            //       currentColor = widget.baseColor;
            //     }
            //   });
            // },
            inputFormatters: widget.inputFormatters,
            readOnly: widget.readOnly,
            keyboardType: widget.inputType,
            controller: widget.controller,
            decoration: InputDecoration(
                hintStyle: themeData.textTheme.bodyLarge
                    ?.copyWith(color: Colors.black26),
                border: InputBorder.none,
                hintText: widget.hint,
                contentPadding: const EdgeInsets.all(15.0)),
          ),
        ),
      ],
    );
  }
}
