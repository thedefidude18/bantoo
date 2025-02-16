import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final EdgeInsetsGeometry padding;
  final Widget? prefixIcon;
  final bool readOnly;
  final Widget? suffixIcon;
  final Function(String value)? onChanged;
  final TextInputAction textInputAction;
  const CustomTextField(
      {super.key,
      required this.label,
      this.controller,
      this.initialValue,
      this.onChanged,
      this.padding = const EdgeInsets.all(0),
      this.prefixIcon,
      this.suffixIcon,
      this.readOnly = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        onChanged: (value) {
          widget.onChanged != null ? widget.onChanged!(value) : () {};
          setState(() {});
        },
        readOnly: widget.readOnly,
        textInputAction: TextInputAction.next,
        controller: widget.controller,
        initialValue: widget.initialValue,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorConstant.whiteA700,
          prefixIcon: widget.prefixIcon,
          // suffixIcon: widget.suffixIcon ??
          //     (widget.controller.text.isNotEmpty
          //         ? IconButton(
          //             onPressed: () {
          //               widget.controller.clear();
          //               setState(() {});
          //             },
          //             icon: Transform.rotate(
          //               angle: 45 * math.pi / 180,
          //               child: Icon(
          //                 Icons.add_circle_rounded,
          //                 color: ColorConstant.gray700,
          //               ),
          //             ),
          //           )
          //         : const SizedBox()),
          border: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.black45)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.black45)),

          label: Text(
            widget.label,
          ),
          labelStyle: TextStyle(color: ColorConstant.gray700),
        ),
      ),
    );
  }
}
