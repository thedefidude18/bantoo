import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/auth/widgets/login_card_small.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flexx_bet/ui/components/components.dart';
import 'package:flexx_bet/helpers/helpers.dart';
import 'package:flexx_bet/controllers/controllers.dart';
import 'package:flexx_bet/ui/auth/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController authController = AuthController.to;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _passwordVisible;
  late bool _confirmPasswordVisible;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  void dispose() {
    authController.referralCodeController.clear();
    authController.nameController.clear();
    authController.emailController.clear();
    authController.passwordController.clear();
    authController.confirmPasswordController.clear();
    authController.usernameController.clear();
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,

                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sign Up",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: HEADING_SIZE,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        SizedBox(
                            height: 30,
                            child: Image.asset(ImageConstant.newLogo)),



                       ]

                    ),
                    const SizedBox(height: 28.0),
                    FormInputField(
                      controller: authController.referralCodeController,
                      labelText: 'auth.referralCodeField'.tr,
                      validator: Validator().referralCode,
                      onChanged: (value) {},
                      onSaved: (value) =>
                          authController.referralCodeController.text = value!,
                    ),
                    const FormVerticalSpace(),
                    FormInputField(
                      controller: authController.nameController,
                      labelText: 'auth.nameFormField'.tr,
                      validator: Validator().name,
                      onChanged: (value) {},
                      onSaved: (value) =>
                          authController.nameController.text = value!,
                    ),
                    const FormVerticalSpace(),
                    FormInputField(
                      controller: authController.usernameController,
                      labelText: 'auth.usernameFormField'.tr,
                      validator: Validator().username,
                      onChanged: (value) {},
                      onSaved: (value) =>
                          authController.usernameController.text = value!,
                    ),
                    const FormVerticalSpace(),
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
                    FormInputField(
                      controller: authController.confirmPasswordController,
                      labelText: 'auth.confirmPasswordFormField'.tr,
                      validator: Validator().confirmPassword,
                      obscureText: !_confirmPasswordVisible,
                      onChanged: (value) {},
                      onSaved: (value) {},
                      suffixWidget: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black45,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
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
                          await authController
                              .registerUserWithEmailAndPassword();
                        }
                      },
                      text: "Submit".toUpperCase(),
                    ),
                    const FormVerticalSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: getHorizontalSize(150),
                          color: ColorConstant.gray400,
                        ),
                        const Text("  or  "),
                        Container(
                          height: 1,
                          width: getHorizontalSize(150),
                          color: ColorConstant.gray400,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
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
                          const LoginCardSmall(
                              imagePath: ImageConstant.facebook),
                          SizedBox(
                            width: getHorizontalSize(30),
                          ),
                          const LoginCardSmall(imagePath: ImageConstant.whatsappLogin)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already Have a account? "),
                        GestureDetector(
                          onTap: () {
                            Get.log("To SignInScreen");
                            Get.off(() => const SignInScreen());
                          },
                          child: Text(
                            "Sign In",
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
      ),
    );
  }
}
