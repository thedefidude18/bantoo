import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomOTPTextField extends StatefulWidget {
  final int length;
  final Function(String) onOtpEntered;

  const CustomOTPTextField({
    Key? key,
    required this.length,
    required this.onOtpEntered,
  }) : super(key: key);

  @override
  _CustomOTPTextFieldState createState() => _CustomOTPTextFieldState();
}

class _CustomOTPTextFieldState extends State<CustomOTPTextField> {
  List<TextEditingController> textControllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      textControllers.add(TextEditingController());
      textControllers[i].addListener(() {
        _updateOtpValues();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          widget.length,
              (index) => SizedBox(
            width: 50,
            child: Card(
              elevation: 6,
              shadowColor: ColorConstant.primaryColor,
              child: TextField(
                controller: textControllers[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: ColorConstant.fieldColorD6E4F3,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < widget.length - 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateOtpValues() {
    String otpValue = '';
    for (int i = 0; i < textControllers.length; i++) {
      otpValue += textControllers[i].text;
    }
    widget.onOtpEntered(otpValue);
  }
}
