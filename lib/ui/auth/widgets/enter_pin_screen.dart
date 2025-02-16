import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flexx_bet/ui/auth/widgets/forget_pin_screen.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/home/landing_page_ui.dart';
import '../../../constants/colors.dart';
import '../../../controllers/landing_page_controller.dart';

class EnterPinScreen extends StatefulWidget {
  final String pin;

  EnterPinScreen(this.pin, {Key? key}) : super(key: key);

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  final Rxn<User> _firebaseUser = Rxn<User>();

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers = List.generate(4, (index) => TextEditingController());
    _focusNodes = List.generate(4, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: TextStyle(
                color: ColorConstant.black900,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 30,
              ),
            ),
            Text(
              _firebaseUser.value?.displayName ?? "@user",
              style: TextStyle(
                color: ColorConstant.greay3C3C43,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "Enter Pin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstant.black900,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
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
                          _focusNodes[index].unfocus();
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomButton(
                    text: "submit".toUpperCase(),
                    fontStyle: ButtonFontStyle.PoppinsSemiBold14WhiteA700,
                    onTap: () {
                      String enteredPin = _controllers
                          .map((controller) => controller.text)
                          .join();
                      if (enteredPin == widget.pin) {
                        navigateToHome();
                      } else {
                        showToast();
                      }
                    },
                  ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Get.to(ForgetPinScreen());
              },
              child: Center(
                child: Text(
                  "Forget Pin?",
                  style: TextStyle(
                    color: ColorConstant.primaryColor,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  navigateToHome() async {
    setState(() {
      _isLoading = true;
    });
    Get.log('Send to Detailed event screen');
    LandingPageController.to.changeTabIndex(0);
    setState(() {
      _isLoading = false;
    });
    Get.offAll(() => LandingPage());
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "Pin is Incorrect",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
