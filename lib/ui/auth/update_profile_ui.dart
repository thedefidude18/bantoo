// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:flexx_bet/models/models.dart';
// import 'package:flexx_bet/ui/components/components.dart';
// import 'package:flexx_bet/helpers/helpers.dart';
// import 'package:flexx_bet/controllers/controllers.dart';
// import 'package:flexx_bet/ui/auth/auth.dart';

// class UpdateProfileScreen extends StatelessWidget {
//   final AuthController authController = AuthController.to;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   UpdateProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     //print('user.name: ' + user?.value?.name);
//     authController.nameController.text =
//         authController.userFirestore!.name;
//     authController.emailController.text =
//         authController.userFirestore!.email;
//     return Scaffold(
//       appBar: AppBar(title: Text('auth.updateProfileTitle'.tr)),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   LogoGraphicHeader(),
//                   const SizedBox(height: 48.0),
//                   FormInputFieldWithIcon(
//                     controller: authController.nameController,
//                     iconPrefix: Icons.person,
//                     labelText: 'auth.nameFormField'.tr,
//                     validator: Validator().name,
//                     onChanged: (value) {},
//                     onSaved: (value) =>
//                         authController.nameController.text = value!,
//                   ),
//                   const FormVerticalSpace(),
//                   FormInputFieldWithIcon(
//                     controller: authController.emailController,
//                     iconPrefix: Icons.email,
//                     labelText: 'auth.emailFormField'.tr,
//                     validator: Validator().email,
//                     keyboardType: TextInputType.emailAddress,
//                     onChanged: (value) {},
//                     onSaved: (value) =>
//                         authController.emailController.text = value!,
//                   ),
//                   const FormVerticalSpace(),
//                   PrimaryButton(
//                       labelText: 'auth.updateUser'.tr,
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           SystemChannels.textInput
//                               .invokeMethod('TextInput.hide');
//                           UserModel updatedUser = UserModel.newUser(
//                             uid: authController.userFirestore!.uid,
//                             email: authController.emailController.text,
//                             name: authController.nameController.text,
//                             username: authController.usernameController.text,
//                             photoUrl:
//                                 authController.userFirestore!.photoUrl,
//                           );
//                           _updateUserConfirm(context, updatedUser,
//                               authController.userFirestore!.email);
//                         }
//                       }),
//                   const FormVerticalSpace(),
//                   LabelButton(
//                     labelText: 'auth.resetPasswordLabelButton'.tr,
//                     onPressed: () => Get.to(ResetPasswordScreen()),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _updateUserConfirm(
//       BuildContext context, UserModel updatedUser, String oldEmail) async {
//     final AuthController authController = AuthController.to;
//     final TextEditingController password = TextEditingController();
//     return Get.dialog(
//       AlertDialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8.0))),
//         title: Text(
//           'auth.enterPassword'.tr,
//         ),
//         content: FormInputFieldWithIcon(
//           controller: password,
//           iconPrefix: Icons.lock,
//           labelText: 'auth.passwordFormField'.tr,
//           validator: (value) {
//             String pattern = r'^.{6,}$';
//             RegExp regex = RegExp(pattern);
//             if (!regex.hasMatch(value!)) {
//               return 'validator.password'.tr;
//             } else {
//               return null;
//             }
//           },
//           obscureText: true,
//           onChanged: (value) {},
//           onSaved: (value) => password.text = value!,
//           maxLines: 1,
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('auth.cancel'.tr.toUpperCase()),
//             onPressed: () {
//               Get.back();
//             },
//           ),
//           TextButton(
//             child: Text('auth.submit'.tr.toUpperCase()),
//             onPressed: () async {
//               Get.back();
//               // await authController.updateUserEmail(
//               //     updatedUser, oldEmail, password.text);
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
