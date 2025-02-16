// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flexx_bet/ui/auth/auth.dart';
// import 'package:flexx_bet/ui/components/components.dart';
// import 'package:flexx_bet/helpers/helpers.dart';
// import 'package:flexx_bet/controllers/controllers.dart';

// class ResetPasswordScreen extends StatelessWidget {
//   final AuthController authController = AuthController.to;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   ResetPasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(context),
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
//                     controller: authController.emailController,
//                     iconPrefix: Icons.email,
//                     labelText: 'auth.emailFormField'.tr,
//                     validator: Validator().email,
//                     keyboardType: TextInputType.emailAddress,
//                     onChanged: (value) {},
//                     onSaved: (value) =>
//                         authController.emailController.text = value as String,
//                   ),
//                   const FormVerticalSpace(),
//                   PrimaryButton(
//                       labelText: 'auth.resetPasswordButton'.tr,
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           await authController.sendPasswordResetEmail(context);
//                         }
//                       }),
//                   const FormVerticalSpace(),
//                   signInLink(context),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   appBar(BuildContext context) {
//     if (authController.emailController.text == '') {
//       return null;
//     }
//     return AppBar(title: Text('auth.resetPasswordTitle'.tr));
//   }

//   signInLink(BuildContext context) {
//     if (authController.emailController.text == '') {
//       return LabelButton(
//         labelText: 'auth.signInonResetPasswordLabelButton'.tr,
//         onPressed: () => Get.offAll(() => SignInScreen()),
//       );
//     }
//     return const SizedBox(width: 0, height: 0);
//   }
// }
