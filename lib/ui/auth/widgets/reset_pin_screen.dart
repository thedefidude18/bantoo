import 'package:flexx_bet/ui/auth/widgets/enter_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flexx_bet/ui/auth/widgets/forget_pin_screen.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../controllers/auth_controller.dart';

class ResetPinScreen extends StatefulWidget {
  const ResetPinScreen({Key? key}) : super(key: key);

  @override
  State<ResetPinScreen> createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final AuthController _authController = AuthController.to;
   List<TextEditingController> _resetPinControllers = [];
   List<TextEditingController> _confirmResetPinControllers = [];
   List<FocusNode> _resetPinFocusNodes = [];
   List<FocusNode> _confirmResetPinFocusNodes = [];
   bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _resetPinControllers = List.generate(
      4,
          (index) => TextEditingController(),
    );
    _confirmResetPinControllers = List.generate(
      4,
          (index) => TextEditingController(),
    );
    _resetPinFocusNodes = List.generate(
      4,
          (index) => FocusNode(),
    );
    _confirmResetPinFocusNodes = List.generate(
      4,
          (index) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (var i = 0; i < _resetPinControllers.length; i++) {
      _resetPinControllers[i].dispose();
      _confirmResetPinControllers[i].dispose();
      _resetPinFocusNodes[i].dispose();
      _confirmResetPinFocusNodes[i].dispose();
    }
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please enter your new\npin",
              style: TextStyle(
                color: ColorConstant.black900,
                fontFamily: 'Poppins',
                fontSize: 26,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Please enter your new pin and confirm it.",
                style: TextStyle(
                  color: ColorConstant.greay3C3C43,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 63,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConstant.gray300,
                        width: 1,
                      ),
                      color: ColorConstant.pinFieldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _resetPinControllers[index],
                      focusNode: _resetPinFocusNodes[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstant.black900,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _resetPinFocusNodes[index].unfocus();
                          FocusScope.of(context).requestFocus(_resetPinFocusNodes[index + 1]);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Confirm new PIN",
                style: TextStyle(
                  color: ColorConstant.greay3C3C43,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 63,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConstant.gray300,
                        width: 1,
                      ),
                      color: ColorConstant.pinFieldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _confirmResetPinControllers[index],
                      focusNode: _confirmResetPinFocusNodes[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstant.black900,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _confirmResetPinFocusNodes[index].unfocus();
                          FocusScope.of(context).requestFocus(_confirmResetPinFocusNodes[index + 1]);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          _isLoading? Center(child: CircularProgressIndicator(),): CustomButton(
              text: "reset pin".toUpperCase(),
              fontStyle: ButtonFontStyle.PoppinsSemiBold14WhiteA700,
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });


                String pin = '';
                for (var controller in _confirmResetPinControllers) {
                  pin += controller.text;
                }
                _authController.pinTextController.text = pin;
                await _authController.resetUserPin();
               Future.delayed(Duration(seconds: 2)).then((value){
                 setState(() {
                   _isLoading = false;
                 });
                 showToast();
                 Get.to(EnterPinScreen(pin));
               });
              },
            ),
          ],
        ),
      ),
    );
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "Your pin changed successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: ColorConstant.primaryColor,
      textColor: Colors.white,

    );}
}
