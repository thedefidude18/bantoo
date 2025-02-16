
import 'package:flexx_bet/ui/auth/sign_in_with_phone.dart';
import 'package:flexx_bet/ui/auth/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/app_themes.dart';
import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/auth_controller.dart';
import '../../helpers/size.dart';
import '../components/custom_button.dart';
import '../components/form_vertical_spacing.dart';

class OtpScreenForPhone extends StatefulWidget {
  const OtpScreenForPhone({super.key});

  @override
  State<OtpScreenForPhone> createState() => _OtpScreenForPhoneState();
}

class _OtpScreenForPhoneState extends State<OtpScreenForPhone> {
  final AuthController authController = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
             statusBarIconBrightness: Brightness.dark,
        )
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Flexible(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: (){
                    Get.to(() => const SignInWithPhone());
                  },
                  child: Image.asset(
                    ImageConstant.goBackIcon,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40,right: 4),
                      child: Container(
                        height: 100,
                        width: 290,
                        decoration: BoxDecoration(
                          color: ColorConstant.primaryColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            "auth.otpText".tr,style: TextStyle(
                              color: ColorConstant.whiteA700,
                            fontFamily: AppThemes.font2,
                          ),),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 25,
                      bottom: 16,
                      child: Image.asset(
                        ImageConstant.rightImage,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),
          const FormVerticalSpace(),
          const FormVerticalSpace(),
          Text(
            "auth.otp".tr,
            style: TextStyle(
                color: ColorConstant.signinText404699,
                fontSize: 20,
                fontFamily: AppThemes.font2,
                fontWeight: FontWeight.w500),
          ),
          const FormVerticalSpace(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomOTPTextField(length: 6,
              onOtpEntered: (otpValue) {
                authController.smsCode = otpValue;
                print('Entered OTP: $otpValue');
                // Do whatever you want with the OTP value here
              },),
          ),
          const FormVerticalSpace(),
         Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Text("auth.resendOtp".tr,style: TextStyle(fontFamily: AppThemes.font2,),),
             const SizedBox(
               height: 20,
             ),
             CustomButton(
               height: getVerticalSize(45),
               width: 100,
               fontStyle: ButtonFontStyle.PoppinsMedium16,
               onTap: () async {
                 authController.otpSend((isLoading){});
               },
               text: "Resend".toUpperCase(),
             ),
           ],
         ),
         const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 25,right: 25),
            child: CustomButton(
              height: getVerticalSize(60),
              fontStyle: ButtonFontStyle.PoppinsMedium16,
              onTap: () async {
                authController.verifyOtp();
              },
              text: "Submit".toUpperCase(),
            ),
          ),

        ],
      ),
    );
  }
}

