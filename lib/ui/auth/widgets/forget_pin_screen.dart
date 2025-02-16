import 'package:flexx_bet/ui/auth/widgets/reset_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../components/custom_button.dart';

class ForgetPinScreen extends StatefulWidget {
  const ForgetPinScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPinScreen> createState() => _ForgetPinScreenState();
}

class _ForgetPinScreenState extends State<ForgetPinScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  final _phoneNumberRegex = RegExp(r'^[0-9]{10}$'); // Regular expression for 10-digit phone number

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset your Bantah PIN",
              style: TextStyle(
                color: ColorConstant.black900,
                fontFamily: 'Poppins',
                fontSize: 26,
              ),
            ),
            Text(
              "Please enter your Phone number to\nreceive a new PIN",
              style: TextStyle(
                color: ColorConstant.greay3C3C43,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            // Custom phone number text field
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: ColorConstant.gray700, width: 1.5),
                ),
                hintText: 'Phone number',
                hintStyle: TextStyle(color: ColorConstant.gray700),
                suffixIcon: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ColorConstant.gray600,
                    ),
                    height: 20,
                    width: 20,
                    child: Icon(
                      Icons.clear_rounded,
                      color: ColorConstant.whiteA700,
                      size: 12,
                    ),
                  ),
                  onPressed: () {
                    _phoneNumberController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Validation message
            _phoneNumberController.text.isEmpty || _phoneNumberRegex.hasMatch(_phoneNumberController.text)
                ? SizedBox()
                : Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Please enter a valid 10-digit phone number',
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: "reset pin".toUpperCase(),
              fontStyle: ButtonFontStyle.PoppinsSemiBold14WhiteA700,
              onTap: () {
                if (_phoneNumberController.text.isNotEmpty && _phoneNumberRegex.hasMatch(_phoneNumberController.text)) {
                  Get.to(ResetPinScreen());
                } else {
                  setState(() {}); // To trigger the validation message update
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
