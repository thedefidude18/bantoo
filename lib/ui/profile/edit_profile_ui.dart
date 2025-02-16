import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/helpers/validator.dart';
import 'package:flexx_bet/ui/components/components.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_text_field.dart';
import 'package:flexx_bet/ui/profile/change_email_ui.dart';
import 'package:flexx_bet/ui/profile/widget/custom_dropdown.dart';
import 'package:flexx_bet/ui/profile/widget/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    authController.countryCode = authController.userFirestore!.countryCode;
    authController.country = authController.userFirestore!.country;
    authController.numberController.text = authController.userFirestore!.number;
    authController.aboutController.text = authController.userFirestore!.about;
    authController.addressController.text =
        authController.userFirestore!.address;
    authController.nameController.text = authController.userFirestore!.name;
    authController.usernameController.text =
        authController.userFirestore!.username;
    super.initState();
  }

  @override
  void dispose() {
    authController.usernameController.clear();
    authController.nameController.clear();
    authController.numberController.clear();
    authController.addressController.clear();
    authController.aboutController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
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
                const FormVerticalSpace(),
                FormInputField(
                  controller: authController.nameController,
                  labelText: "Name",
                  validator: Validator().name,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  onSaved: (value) =>
                      authController.nameController.text = value!,
                ),
                const FormVerticalSpace(),
                FormInputField(
                  controller: authController.usernameController,
                  labelText: "Username",
                  validator: Validator().username,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {},
                  onSaved: (value) =>
                      authController.usernameController.text = value!,
                ),
                const FormVerticalSpace(),
                FormInputField(
                  controller: authController.aboutController,
                  labelText: "Bio",
                  validator: null,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                  onSaved: (value) =>
                      authController.aboutController.text = value!,
                ),
                const FormVerticalSpace(),
                CustomTextField(
                  initialValue: authController.userFirestore!.email,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  label: 'Email',
                  readOnly: true,
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.log("To ChangeEmailScreen");
                            Get.to(() => const ChangeEmailScreen());
                          },
                          child: Text(
                            "Change Email",
                            style: TextStyle(
                                color: ColorConstant.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const FormVerticalSpace(),
                FormInputFieldWithIcon(
                  controller: authController.numberController,
                  labelText: "Phone",
                  validator: Validator().number,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                  iconPrefix: CountryCodePicker(
                    showFlag: true,
                    initialSelection: authController.countryCode,
                    onChanged: (val) {
                      authController.countryCode = val.dialCode ??
                          CountryCodes.detailsForLocale().dialCode;
                    },
                    favorite: const ["+234"],
                    showOnlyCountryWhenClosed: false,
                    hideMainText: true,
                    alignLeft: false,
                  ),
                  onSaved: (value) =>
                      authController.numberController.text = value!,
                ),
                const FormVerticalSpace(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 65,
                        width: Get.width / 2.4,
                        child: DropdownButtonFormField(
                            value: authController.country,
                            isExpanded: true,
                            decoration: InputDecoration(
                                isDense: false,
                                fillColor: ColorConstant.whiteA700,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorConstant.primaryColor,
                                    width: 1,
                                  ),
                                )),
                            onChanged: (newValue) {
                              setState(() {
                                authController.country = newValue ??
                                    CountryCodes.detailsForLocale().name!;
                              });
                            },
                            items: CountryCodes.countryCodes()
                                .map((e) => DropdownMenuItem(
                                      value: e!.name,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        e.name!,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ))
                                .toList()),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 65,
                        width: Get.width / 2.4,
                        child: CustomDropDown(
                          width: Get.width / 2.4,
                          items: const ['Male', 'Female'],
                        ),
                      )
                    ],
                  ),
                ),
                const FormVerticalSpace(),
                FormInputField(
                  controller: authController.addressController,
                  labelText: "Address",
                  validator: null,
                  keyboardType: TextInputType.streetAddress,
                  onChanged: (value) {},
                  onSaved: (value) =>
                      authController.addressController.text = value!,
                ),
                const FormVerticalSpace(),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  padding: ButtonPadding.PaddingAll16,
                  height: 50,
                  text: "Submit",
                  fontStyle: ButtonFontStyle.PoppinsSemiBold14WhiteA700,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await SystemChannels.textInput
                          .invokeMethod('TextInput.hide');

                      await authController.updateUserProfile();
                      SuccessDialog.show("Profile");
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
