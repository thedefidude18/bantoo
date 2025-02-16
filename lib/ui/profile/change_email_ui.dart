import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/helpers/validator.dart';
import 'package:flexx_bet/ui/components/components.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
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
    authController.pinTextController.clear();
    authController.passwordController.clear();
    authController.emailController.clear();
    authController.confirmEmailController.clear();
    super.dispose();
  }

  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Email",
          style: TextStyle(color: ColorConstant.black900),
        ),
        backgroundColor: ColorConstant.whiteA700,
        leading: BackButton(color: ColorConstant.black900),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(height: 48.0),
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
                  controller: authController.confirmEmailController,
                  labelText: 'auth.emailFormField'.tr,
                  validator: Validator().confirmEmail,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                  onSaved: (value) =>
                      authController.emailController.text = value!,
                ),
                const FormVerticalSpace(),
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  "Enter Pin to confirm new Email",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    autoDisposeControllers: false,
                    obscureText: false,
                    controller: authController.pinTextController,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      activeFillColor: ColorConstant.blueGray100,
                      activeColor: ColorConstant.gray200,
                      selectedFillColor: ColorConstant.blueGray100,
                      selectedColor: ColorConstant.blue400,
                      inactiveFillColor: ColorConstant.blueGray100,
                      inactiveColor: ColorConstant.gray200,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: Get.height / 16,
                      fieldWidth: Get.width / 6,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: const TextInputType.numberWithOptions(),
                    onChanged: (value) {
                      setState(() {
                        isComplete = !(value.length < 4);
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                CustomButton(
                  padding: ButtonPadding.PaddingAll16,
                  height: 50,
                  text: "Submit",
                  fontStyle: ButtonFontStyle.PoppinsSemiBold14WhiteA700,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await SystemChannels.textInput.invokeMethod(
                          'TextInput.hide'); //to hide the keyboard - if any
                      await authController.updateUserEmail();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
