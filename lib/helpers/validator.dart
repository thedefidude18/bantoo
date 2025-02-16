// matching various patterns for kinds of data
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:get/get.dart';

class Validator {
  Validator();

  String? email(String? value) {
    if (!GetUtils.isEmail(value ?? "")) {
      return 'validator.email'.tr;
    } else {
      return null;
    }
  }

  String? confirmEmail(String? value) {
    if ((value ?? "").trim() != AuthController.to.emailController.text.trim()) {
      return 'validator.confirmEmail'.tr;
    } else {
      return null;
    }
  }

  String? password(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? "")) {
      return 'validator.password'.tr;
    } else {
      return null;
    }
  }

  String? confirmPassword(String? value) {
    if ((value ?? "").trim() !=
        AuthController.to.passwordController.text.trim()) {
      return 'validator.confirmPassword'.tr;
    } else {
      return null;
    }
  }

  String? name(String? value) {
    String pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? "")) {
      return 'validator.name'.tr;
    } else {
      return null;
    }
  }

  String? username(String? value) {
    if (!GetUtils.isUsername(value ?? "")) {
      return 'validator.username'.tr;
    } else {
      return null;
    }
  }

  String? number(String? value) {
    if (value!.length < 10 || value.length > 10) {
      return 'validator.number'.tr;
    } else {
      return null;
    }
  }


  String? amount(String? value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? "")) {
      return 'validator.amount'.tr;
    } else {
      return null;
    }
  }

  String? notEmpty(String? value) {
    String pattern = r'^\S+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? "")) {
      return 'validator.notEmpty'.tr;
    } else {
      return null;
    }
  }

  String? referralCode(String? value){
    if(value != null && value.isNotEmpty){
      if(value.length != 5){
        return "validator.referralCode".tr;
      }
      return null;
    }
    else{
      return null;
    }
  }
}
