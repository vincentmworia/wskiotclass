import 'package:flutter/material.dart';

import '../main.dart';

class InputField extends StatefulWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    this.focusNode,
    required this.autoCorrect,
    required this.enableSuggestions,
    this.textCapitalization,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.onSaved,
    this.initialValue,
    this.keyboard,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final FocusNode? focusNode;
  final bool autoCorrect;
  final bool enableSuggestions;
  final TextInputType? keyboard;
  final TextCapitalization? textCapitalization;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? initialValue;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = (widget.hintText == 'Password' ||
            widget.hintText == 'New Password' ||
            widget.hintText == 'Old Password' ||
            widget.hintText == 'Confirm Password')
        ? true
        : false;
  }

  icon(IconData icon, Color color) => Icon(
        icon,
        size: 30.0,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(15.0),
        child: TextFormField(
          initialValue: widget.initialValue,
          key: widget.key,
          controller: widget.controller,
          keyboardType: widget.keyboard ?? TextInputType.name,
          focusNode: widget.focusNode,
          autocorrect: widget.autoCorrect,
          enableSuggestions: widget.enableSuggestions,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          obscureText: obscureText,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText,
            prefixIcon: icon(widget.icon, MyApp.appPrimaryColor),
            suffixIcon: (widget.hintText == 'Password' ||
                    widget.hintText == 'Old Password' ||
                    widget.hintText == 'New Password' ||
                    widget.hintText == 'Confirm Password')
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: obscureText
                        ? icon(Icons.visibility_off, Colors.grey)
                        : icon(Icons.visibility, MyApp.appPrimaryColor))
                : null,
          ),
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}
