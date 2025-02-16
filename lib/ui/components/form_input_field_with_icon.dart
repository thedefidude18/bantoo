import 'package:flutter/material.dart';
/*
FormInputFieldWithIcon(
                controller: _email,
                iconPrefix: Icons.link,
                labelText: 'Post URL',
                validator: Validator.notEmpty,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                onChanged: (value) => print('changed'),
                onSaved: (value) => print('implement me'),
              ),
*/

class FormInputFieldWithIcon extends StatelessWidget {
  const FormInputFieldWithIcon(
      {super.key,
      required this.controller,
      this.iconPrefix,
      required this.labelText,
      required this.validator,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.minLines = 1,
      this.maxLines,
      this.initialValue,
      required this.onChanged,
      required this.onSaved});

  final TextEditingController controller;
  final Widget? iconPrefix;
  final String labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int minLines;
  final int? maxLines;
  final void Function(String) onChanged;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        filled: true,
        prefixIcon: iconPrefix,
        labelText: labelText,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: /*Palette.focusedinputBorderColor*/ Colors.black87,
              width: 2.0),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
              color: /*Palette.focusedinputBorderColor*/ Colors.black87,
              width: 2.0),
        ),
      ),
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
    );
  }
}
