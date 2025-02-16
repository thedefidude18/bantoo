import 'dart:core';

import 'package:country_picker/country_picker.dart';
import 'package:flexx_bet/constants/app_themes.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/controllers.dart';
import 'package:flexx_bet/helpers/helpers.dart';
import 'package:flexx_bet/ui/components/components.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({super.key});

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  final AuthController authController = AuthController.to;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late Country _selectedCountry;
  bool _isPrivacyChecked = false;
  bool _isTermsOfUseChecked = false;
  bool _isCheckedError = false;

  @override
  void initState() {
    super.initState();
    _selectedCountry = Country(
      phoneCode: '234',
      countryCode: 'NG',
      e164Sc: 1,
      geographic: true,
      level: 2,
      name: 'Nigeria',
      nameLocalized: '',
      example: '1234567890',
      displayName: 'Nigeria (+234)',
      displayNameNoCountryCode: 'United States',
      e164Key: 'US',
      fullExampleWithPlusSign: '+1 1234567890',
    ); // Set default country
  }

  @override
  void dispose() {
    authController.phoneNumberController.clear();
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "phone".tr,
                    style: TextStyle(
                        color: ColorConstant.signinText404699,
                        fontFamily: AppThemes.font2,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  const FormVerticalSpace(),
                  GestureDetector(
                    onTap: _openCountryPickerDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: ColorConstant.fieldColorD6E4F3,
                        border: Border.all(
                            color: ColorConstant.whiteA700, width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("Country/Region",style: TextStyle(color: Colors.grey.shade600,fontFamily: AppThemes.font2,)),
                           const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${_selectedCountry.flagEmoji} ${_selectedCountry.name} (+${_selectedCountry.phoneCode})',
                                style:  TextStyle(fontSize: 18.0,fontFamily: AppThemes.font2,),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 8,top: 4),
                    decoration: BoxDecoration(
                      color: ColorConstant.fieldColorD6E4F3,
                      border: Border.all(
                          color: ColorConstant.whiteA700, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("auth.phoneFormField".tr,style: TextStyle(color: Colors.grey.shade600,fontFamily: AppThemes.font2),),
                        TextFormField(
                          controller: authController.phoneNumberController,
                          validator: Validator().number,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none
                            )
                          ),
                          onChanged: (value) {},
                          onSaved: (value) =>
                              authController.phoneNumberController.text = value!,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: ColorConstant.black900,
                                  fontFamily: AppThemes.font2),
                              children: [
                                 TextSpan(
                                  text: "auth.term1".tr,
                                ),
                                TextSpan(
                                  text: " auth.term2 ".tr,
                                  style: TextStyle(
                                    color: ColorConstant
                                        .primaryColor,
                                      fontFamily: AppThemes.font2
                                  ),
                                ),
                                 TextSpan(
                                  text:
                                      "auth.term3".tr,
                                ),
                              ]),
                        ),
                      ),
                      Checkbox(
                        value: _isPrivacyChecked,
                        onChanged: (value) {
                          setState(() {
                            _isPrivacyChecked = value!;
                            _isCheckedError = false;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: AppThemes.font2,
                                  color: ColorConstant.black900),
                              children: [
                                 TextSpan(
                                  text: "auth.term4".tr,
                                ),
                                TextSpan(
                                  text: " auth.term5 ".tr,
                                  style: TextStyle(
                                    fontFamily: AppThemes.font2,
                                    color: ColorConstant
                                        .primaryColor, // Change to your desired color
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Checkbox(
                        value: _isTermsOfUseChecked,
                        onChanged: (value) {
                          setState(() {
                            _isTermsOfUseChecked = value!;
                            _isCheckedError = false;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  _isCheckedError?Text("auth.termsError".tr,style: TextStyle(color: ColorConstant.red300,fontFamily: AppThemes.font2),):Container(),
                  isLoading?const Center(child: CircularProgressIndicator(),): CustomButton(
                    height: getVerticalSize(60),
                    fontStyle: ButtonFontStyle.PoppinsMedium16,
                    onTap: () async {
                      if (_formKey.currentState!.validate() &&
                          _isPrivacyChecked &&
                          _isTermsOfUseChecked) {
                        authController.countryCodeController.text = _selectedCountry.phoneCode;
                        await SystemChannels.textInput
                            .invokeMethod('TextInput.hide');
                        //print(_selectedCountry.phoneCode);
                        await authController.otpSend((isLoading){
                          setState(() {
                           this.isLoading = isLoading;
                          });
                        });
                      } else {
                        setState(() {
                          _isCheckedError = true;
                        });
                      }
                    },
                    text: "Next".toUpperCase(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openCountryPickerDialog() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }

}
