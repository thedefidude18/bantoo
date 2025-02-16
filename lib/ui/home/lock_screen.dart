// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:local_auth/error_codes.dart' as local_auth_error;
// import '../../constants/colors.dart';
// import '../../controllers/events_controller.dart';
// import '../../controllers/landing_page_controller.dart';
// import 'landing_page_ui.dart';
// import 'package:local_auth_android/local_auth_android.dart';
//
// class LockScreen extends StatefulWidget {
//   const LockScreen({super.key});
//
//   @override
//   State<LockScreen> createState() => _LockScreenState();
// }
//
// class _LockScreenState extends State<LockScreen> {
//   final _localAuthentication = LocalAuthentication();
//   int _isAuthorized = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(26.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.fingerprint, // Use the fingerprint icon
//               size: 68.0,
//               color:
//                   ColorConstant.primaryColor, // Customize the color as needed
//             ),
//             const SizedBox(height: 16.0),
//             const Text(
//               'AUTHENTICATION REQUIRED',
//               style: TextStyle(
//                 fontSize: 14.0,
//                 color: Colors.grey,
//                 letterSpacing: 1.2,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const Text(
//               'Only the person seeing your data should be you.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 32.0),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorConstant
//                     .primaryColor, // Set your desired background color
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(
//                       14.0), // Set to 0.0 for a square button
//                 ),
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isAuthorized = 0;
//                 });
//                 authenticateUser();
//               },
//               icon: const Icon(Icons.lock_open, color: Colors.white),
//               label: const Text(
//                 'Unlock Now',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   bool isAuthorized = false;
//   final EventsController _eventsController =
//       Get.put<EventsController>(EventsController());
//   Future<void> authenticateUser() async {
//     try {
//       isAuthorized = await _localAuthentication.authenticate(
//         localizedReason: "Please authenticate to login",
//         authMessages: <AuthMessages>[
//           const AndroidAuthMessages(
//             signInTitle: 'Enter your Flexxbet PIN',
//             cancelButton: 'No thanks',
//           ),
//         ],
//       );
//     } on PlatformException catch (exception) {
//       if (exception.code == local_auth_error.notAvailable ||
//           exception.code == local_auth_error.passcodeNotSet ||
//           exception.code == local_auth_error.notEnrolled) {
//         // Handle this exception here.
//       }
//     }
//     if (isAuthorized) {
//       Get.log('Send to Detailed event screen');
//
//       await _eventsController.setupDetailedEventPage(null);
//       LandingPageController.to.changeTabIndex(1);
//       Get.offAll(() => LandingPage());
//     } else {
//       _isAuthorized = 1;
//     }
//   }
// }
