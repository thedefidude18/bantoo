import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/auth/widgets/login_card_small.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:get/get.dart';
import 'package:flexx_bet/ui/auth/auth.dart';
import 'package:flexx_bet/ui/components/components.dart';
import 'package:flexx_bet/helpers/helpers.dart';
import 'package:flexx_bet/controllers/controllers.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController authController = AuthController.to;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    authController.emailController.clear();
    authController.passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                      width: 296,
                      height: 80,
                      child: Image.asset(ImageConstant.newLogo)),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: HEADING_SIZE,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48.0),
                  FormInputField(
                    controller: authController.emailController,
                    labelText: 'auth.emailFormField'.tr,
                    validator: Validator().email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                    onSaved: (value) =>
                        authController.emailController.text = value!,
                  ),
                  const FormVerticalSpace(),
                  FormInputField(
                    controller: authController.passwordController,
                    labelText: 'auth.passwordFormField'.tr,
                    validator: Validator().password,
                    obscureText: !_passwordVisible,
                    onChanged: (value) {},
                    onSaved: (value) =>
                        authController.passwordController.text = value!,
                    suffixWidget: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  const FormVerticalSpace(),
                  CustomButton(
                    height: getVerticalSize(60),
                    fontStyle: ButtonFontStyle.PoppinsMedium16,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await SystemChannels.textInput.invokeMethod(
                            'TextInput.hide'); //to hide the keyboard - if any
                        await authController.signInUserWithEmailAndPassword();
                      }
                    },
                    text: "Submit".toUpperCase(),
                  ),
                  SizedBox(
                    height: getVerticalSize(20),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Text("Forgot password?",style: TextStyle(
                        fontSize: 17.12,
                      ),),

                    ],
                  ),
                  SizedBox(
                    height: getVerticalSize(70),
                  ),
                  const FormVerticalSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: getHorizontalSize(130),
                        color: ColorConstant.gray400,
                      ),
                      const Text("  or continue with   "),
                      Container(
                        height: 1,
                        width: getHorizontalSize(130),
                        color: ColorConstant.gray400,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: getVerticalSize(50),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const LoginCardSmall(imagePath: ImageConstant.apple),
                        GestureDetector(
                            onTap: () async {
                              await AuthController.to
                                  .registerOrSignInUserWithGoogle();
                            },
                            child: const LoginCardSmall(
                                imagePath: ImageConstant.google)),
                        SizedBox(
                          width: getHorizontalSize(30),
                        ),
                        const LoginCardSmall(imagePath: ImageConstant.facebook),
                        SizedBox(
                          width: getHorizontalSize(30),
                        ),
                        const LoginCardSmall(imagePath: ImageConstant.whatsappLogin)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getVerticalSize(70),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have a account? "),
                      GestureDetector(
                        onTap: () {
                          Get.log("TO SignUpScreen");
                          Get.off(() => const SignUpScreen());
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: ColorConstant.blue400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
