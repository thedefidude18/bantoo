import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class FormInputField extends StatelessWidget {
  const FormInputField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.validator,
      this.initialValue,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.suffixWidget,
      required this.onChanged,
      required this.onSaved});

  final TextEditingController controller;
  final String labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixWidget;
  final void Function(String) onChanged;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        suffixIcon: suffixWidget,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        ),
        enabledBorder:  const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF797979), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        fillColor: const Color(0xFFFFFFFF),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: /*Palette.focusedinputBorderColor*/ Colors.black87,
              width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        filled: true,
        //Palette.inputFillColor,
        labelText: labelText,
      ),
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
