import 'dart:io';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexx_bet/controllers/achievements_controller.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/models/UserDetailModel.dart';
import 'package:flexx_bet/models/verification_request_model.dart';
import 'package:flexx_bet/ui/auth/create_pin_ui.dart';
import 'package:flexx_bet/ui/auth/identity_verfication_ui.dart';
import 'package:flexx_bet/ui/auth/widgets/enter_pin_screen.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flexx_bet/ui/home/landing_page_ui.dart';
import 'package:flexx_bet/ui/home/lock_screen.dart';
import 'package:flexx_bet/ui/onboarding/onboarding_ui.dart';
import 'package:flexx_bet/ui/profile/widget/success_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/models/models.dart';
import 'package:flexx_bet/ui/components/components.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:tiktok_login_flutter/tiktok_login_flutter.dart';
import '../models/transaction_model.dart';
import '../ui/auth/otp_screen_for_phone.dart';
import '../ui/auth/signup_singin_choice_ui.dart';
import '../ui/notifications_and_bethistory/push_notification.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find<AuthController>();
  final EventsController _eventsController =
      Get.put<EventsController>(EventsController());
  final WalletContoller _walletContoller =
      Get.put<WalletContoller>(WalletContoller());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard(scopes: ['email']);
  late VerificationRequestModel verificationRequest;
  final Rxn<User> _firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  Rxn<UserDetailModel> firestoreUserdetail = Rxn<UserDetailModel>();
  bool firstTimeUser = false;
  final RxBool admin = false.obs;
  static const String defaultPicture =
      "https://firebasestorage.googleapis.com/v0/b/flexxbet.appspot.com/o/user_default.png?alt=media&token=21e970c2-55e9-4a3e-99bc-6a12a5338466";

  List<QueryDocumentSnapshot<Map<String, dynamic>>> documentList = [];
  UserModel? otherUser;
  List<UserModel?> usersPresent = [];
  String? country;
  String? countryCode;
  String gender = "";
  String verificationId = "";
  String smsCode = "";

  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pinTextController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  int _isAuthorized = 0;

  @override
  void onReady() async {
    await CountryCodes.init();
    //run every time auth state changes
    ever(_firebaseUser, handleAuthChanged);

    _firebaseUser.bindStream(user);
    initDynamicLinks();
    super.onReady();
  }

  Future<void> initDynamicLinks() async {
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data;

    /// When app is killed state
    if (deepLink != null) {
      referralCodeController.text =
          deepLink.link.queryParameters['invitedCode'] ?? '';
    }

    /// When app is live and background state
    dynamicLinks.onLink.listen((dynamicLinkData) {
      referralCodeController.text =
          dynamicLinkData.link.queryParameters['invitedCode'] ?? '';
    }).onError((error) {
      print(error.message);
    });
  }

  Future<void> initFirestoreUserStream() {
    Get.log("initStream");
    firestoreUser.bindStream(streamFirestoreUser());
    var firstValueReceived = Completer<void>();
    firestoreUser.listen((val) {
      if (!firstValueReceived.isCompleted) {
        firstValueReceived.complete();
      }
    });
    return firstValueReceived.future;
  }

  void handleAuthChanged(User? firebaseUser) async {
    Get.log("handleAuthChanged");
    //get user data from firestore
    if (Get.currentRoute != "/test-screen") {
      if (firebaseUser != null) {
        await initFirestoreUserStream();
        await WalletContoller.to.setupUserWallet(userFirestore!);
        await AchievementController.to.setupUserAchievements(userFirestore!);
        await isAdmin();
        if (firstTimeUser != true) {
          if (userFirestore!.pin == "") {
            Get.log('Send to CreatePinScreen');

            Get.offAll(() => const CreatePinScreen());
          } else {
            Get.log('Send to Detailed event screen');

            await _eventsController.setupDetailedEventPage(null);
            // LandingPageController.to.changeTabIndex(1);
            // Get.offAll(() => LandingPage());
            Get.offAll(() => EnterPinScreen(userFirestore!.pin));
          }
        } else {
          Get.offAll(() => const IdentityVerficationScreen());
        }
      } else {
        Get.log('Send to onboarding');

        Get.offAll(() => SignupSignInChoiceScreen());
      }
    }
  }

  get isAuthenticated => _firebaseUser.value != null;
  // Firebase user one-time fetch
  Future<User?> get getUser async => _auth.currentUser;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  UserModel? get userFirestore => firestoreUser.value;
  UserDetailModel? get userdetailFirestore => firestoreUserdetail.value;

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser() {
    if (kDebugMode) {
      Get.log('streamFirestoreUser()');
    }

    return _db
        .doc('/users/${_firebaseUser.value!.uid}')
        .snapshots()
        .map((snapshot) {
      if (snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data()!);
      } else {
        UserModel newUser = UserModel.newUser(
          uid: _firebaseUser.value!.uid,
          email: _firebaseUser.value!.email ?? '',
          phone: _firebaseUser.value!.phoneNumber ?? "",
          name: _firebaseUser.value!.displayName ?? "",
          country: CountryCodes.detailsForLocale().name ?? '',
          countryCode: CountryCodes.detailsForLocale().dialCode ?? '',
          userRef: referralCodeController.text,
          username: "",
          photoUrl: _firebaseUser.value!.photoURL ?? "",
        );
        _createUserFirestore(newUser, _firebaseUser.value!);
        return newUser;
      }
    });
  }

  Future fetchFirstUserList() async {
    await showLoader(() async {
      Get.log("fetchFirstEventsList");
      try {
        documentList = (await _db
                .collection('/users')
                .where("uid", isNotEqualTo: userFirestore!.uid)
                .limit(5)
                .get())
            .docs;

        List<UserModel> users = [];
        for (var value in documentList) {
          users.add(UserModel.fromMap(value.data()));
        }
        usersPresent = users;

        update();
      } catch (e) {
        Get.log(e.toString(), isError: true);
      }
    });
  }

  Future loadFiveNextUsers() async {
    await showLoader(() async {
      Get.log("loadFiveNextEvents");
      try {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> newDocumentList =
            (await _db
                    .collection('/users')
                    .where("uid", isNotEqualTo: userFirestore!.uid)
                    .orderBy("uid", descending: false)
                    .startAfterDocument(documentList.last)
                    .limit(5)
                    .get())
                .docs;
        documentList = newDocumentList;
        for (var element in documentList) {
          usersPresent.add(UserModel.fromMap(element.data()));
        }

        update();
      } catch (e) {
        Get.log(e.toString(), isError: true);
      }
    });
  }

  Future<bool> _checkUserWithEmailExists(String email) {
    Get.log("_checkUserWithEmailExists");
    return _db
        .collection('/users/')
        .where('email', isEqualTo: email)
        .get()
        .then(
            (documentSnapshot) => documentSnapshot.docs.isEmpty ? false : true);
  }

  //get the firestore user from the firestore collection
  Future<UserModel?> _getFirestoreAnotherUser(String userId) async {
    Get.log("_getFirestoreAnotherUser");
    return await _db.doc('/users/$userId').get().then((documentSnapshot) =>
        documentSnapshot.data() == null
            ? null
            : UserModel.fromMap(documentSnapshot.data()!));
  }

  Future loadAnotherUserData(String userId) async {
    Get.log("loadAnotherUserData");
    try {
      otherUser = await _getFirestoreAnotherUser(userId);
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future loadUsersPresent(List userIds) async {
    Get.log("loadUsersPresent");
    try {
      List<UserModel?> newUserList = [];
      for (String userId in userIds) {
        newUserList.add(await _getFirestoreAnotherUser(userId));
      }
      usersPresent = newUserList;
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  //Method to handle user sign in using email and password
  Future signInUserWithEmailAndPassword() async {
    Get.log("signInUserWithEmailAndPassword");
    try {
      await showLoader(() async {
        firstTimeUser = false;
        try {
          await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
        } on FirebaseAuthException catch (error) {
          Get.log(error.toString(), isError: true);
          String errorMessage = 'auth.signInError'.tr;

          // Handle specific Firebase error codes
          switch (error.code) {
            case 'user-not-found':
              errorMessage = 'No user found with this email';
              break;
            case 'wrong-password':
              errorMessage = 'Invalid password';
              break;
            case 'invalid-email':
              errorMessage = 'Invalid email format';
              break;
          }

          Get.snackbar(
            'auth.signInErrorTitle'.tr,
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 7),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor,
          );
        }
      });
    } catch (e) {
      Get.log('Unexpected error during sign in: ${e.toString()}',
          isError: true);
    }
  }

  Future registerOrSignInUserWithGoogle() async {
    Get.log("registerAndSignInUserWithGoogle");
    showLoadingIndicator();
    try {
      firstTimeUser = false;
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        Get.snackbar('auth.signInErrorTitle'.tr, 'auth.signInErrorGoogle'.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 7),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
        return;
      }
      bool emailExists =
          await _checkUserWithEmailExists(googleSignInAccount.email);

      if (emailExists) {
        firstTimeUser = false;
      } else {
        firstTimeUser = true;
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _auth.signInWithCredential(credential);

      if (referralCodeController.text.isNotEmpty) {
        UserModel? userModel =
            await _checkReferralCode(referralCodeController.text);
        if (userModel != null) {
          await _updateReferralBonus(userModel.uid);
        }
      }

      update();
    } catch (error) {
      Get.log(error.toString(), isError: true);
      Get.snackbar('auth.signInErrorTitle'.tr, 'Something went wrong'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
    // hideLoadingIndicator();
  }

  // User registration using email and password
  Future registerUserWithEmailAndPassword() async {
    Get.log("registerUserWithEmailAndPassword");
    showLoader(() async {
      try {
        firstTimeUser = true;
        await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((result) async {
          if (kDebugMode) {
            Get.log('uID: ${result.user?.uid}');
            Get.log('email: ${result.user?.email}');
          }

          //create the new user object
          UserModel newUser = UserModel.newUser(
            userRef: referralCodeController.text,
            uid: result.user?.uid ?? "",
            email: result.user?.email ?? "",
            phone: result.user?.phoneNumber ?? "",
            name: nameController.text,
            country: CountryCodes.detailsForLocale().name ?? "",
            countryCode: CountryCodes.detailsForLocale().dialCode ?? "",
            username: usernameController.text,
            photoUrl: defaultPicture,
          );
          //create the user in firestore
          _createUserFirestore(newUser, result.user!);
        });
      } on FirebaseAuthException catch (error) {
        Get.log(error.toString(), isError: true);
        Get.snackbar('auth.signUpErrorTitle'.tr, error.message!,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 10),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      } catch (e) {
        Get.log(e.toString(), isError: true);
      }
    });
  }

  //handles updating the user when updating profile
  Future<void> updateUserEmail() async {
    Get.log("updateUserEmail");

    showLoader(() async {
      try {
        UserCredential firebaseUser = await _auth.signInWithEmailAndPassword(
            email: userFirestore!.email,
            password: passwordController.text.trim());
        if (pinTextController.text.trim() == userFirestore!.pin) {
          await firebaseUser.user!
              .updateEmail(emailController.text.trim())
              .then((value) => _updateUserFirestore(userFirestore!));
          SuccessDialog.show("Email");
        } else {
          Get.snackbar(
              "Invalid Pin", "Pin you entered is not correct for this account",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 5),
              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
              colorText: Get.theme.snackBarTheme.actionTextColor);
        }
      } catch (err) {
        if (kDebugMode) {
          Get.log('Caught error: $err');
        }
        String authUpdateUserNoticeTitle;
        String authUpdateUserNotice;
        if (err.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          authUpdateUserNoticeTitle = 'auth.updateUserEmailInUse'.tr;
          authUpdateUserNotice = 'auth.updateUserEmailInUse'.tr;
        } else {
          authUpdateUserNoticeTitle = 'auth.wrongPasswordNotice'.tr;
          authUpdateUserNotice = 'auth.wrongPasswordNotice'.tr;
        }
        Get.snackbar(authUpdateUserNoticeTitle, authUpdateUserNotice,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      }
    });
  }

  Future<void> updateUserPassword() async {
    Get.log("updateUserPassword");
    showLoadingIndicator();
    try {
      UserCredential firebaseUser = await _auth.signInWithEmailAndPassword(
          email: userFirestore!.email,
          password: oldPasswordController.text.trim());
      if (pinTextController.text.trim() == userFirestore!.pin) {
        await firebaseUser.user!.updatePassword(passwordController.text.trim());
        SuccessDialog.show("Password");
      } else {
        Get.snackbar(
            "Invalid Pin", "Pin you entered is not correct for this account",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      }
    } catch (err) {
      if (kDebugMode) {
        Get.log('Caught error: $err');
      }
      if (err.toString() ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        Get.snackbar(
            'Update password failure', "auth.wrongOldPasswordNotice".tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 10),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      } else {
        Get.snackbar('auth.unknownError'.tr,
            "There was a Error updating Password, please try later",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 10),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      }
    }
    hideLoadingIndicator();
  }

  Future followAnotherUser() async {
    Get.log("followAnotherUser");
    await showLoader(() async {
      try {
        if (otherUser!.uid == userFirestore!.uid) {
          return;
        }

        List followers = otherUser!.followers;
        followers.add(userFirestore!.uid);
        Get.log("added follower");

        UserModel followedUserModel = otherUser!.updateImmutable(
          followers: followers,
        );

        List following = userFirestore!.following;
        following.add(otherUser!.uid);
        Get.log("added following");
        UserModel followedByUserModel = userFirestore!.updateImmutable(
          following: following,
        );

        await _updateUserFirestore(followedUserModel);
        await _updateUserFirestore(followedByUserModel);
      } catch (e) {
        Get.log(e.toString(), isError: true);
      }
    });
  }

  Future removeFollow() async {
    Get.log("removeFromUserFollowers");
    await showLoader(() async {
      try {
        if (otherUser!.uid == userFirestore!.uid) {
          return;
        }

        List followers = otherUser!.followers;
        if (followers.remove(userFirestore!.uid)) {
          Get.log("removed follower");

          UserModel followedUserModel = otherUser!.updateImmutable(
            followers: followers,
          );
          await _updateUserFirestore(followedUserModel);
        }

        List following = userFirestore!.following;
        if (following.remove(otherUser!.uid)) {
          Get.log("added following");
          UserModel followedByUserModel = userFirestore!.updateImmutable(
            following: following,
          );

          await _updateUserFirestore(followedByUserModel);
        }
      } catch (e) {
        Get.log(e.toString(), isError: true);
      }
    });
  }

  Future addBetInUserRecord(String betId) async {
    Get.log("addBetInUserRecord");
    showLoader(() async {
      try {
        List allBetsFirs = [...userFirestore!.allBets, betId];
        UserModel userModel1 = userFirestore!.updateImmutable(
          allBets: allBetsFirs,
        );
        List allBetsSec = [...otherUser!.allBets, betId];
        UserModel userModel2 = otherUser!.updateImmutable(
          allBets: allBetsSec,
        );

        _updateUserFirestore(userModel2);
        _updateUserFirestore(userModel1);
      } catch (e) {
        Get.log(e.toString(), isError: true);
      }
    });
  }

  Future updateUserProfileImage(File image) async {
    Get.log("updateUserProfileImage");
    showLoadingIndicator();
    try {
      Reference reference =
          _storage.ref().child("profile_image${_firebaseUser.value!.uid}");
      UploadTask uploadTask = reference.putFile(image);
      late UserModel userModel;
      await uploadTask.whenComplete(() async {
        userModel = userFirestore!.updateImmutable(
          photoUrl: await reference.getDownloadURL(),
        );

        if (kDebugMode) {
          Get.log("The url ${userModel.photoUrl}");
        }
      });
      _updateUserFirestore(userModel);
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
    hideLoadingIndicator();
  }

  Future updateUserPin() async {
    Get.log("updateUserPin");
    showLoadingIndicator();
    try {
      UserModel userModel = userFirestore!.updateImmutable(
        pin: pinTextController.text.trim(),
      );

      if (kDebugMode) {
        Get.log("The url ${userModel.photoUrl}");
      }

      _updateUserFirestore(userModel);
      pinTextController.clear();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
    hideLoadingIndicator();
  }

  Future resetUserPin() async {
    Get.log("updateUserPin");
    //showLoadingIndicator();
    try {
      UserModel userModel = userFirestore!.updateImmutable(
        pin: pinTextController.text.trim(),
      );

      if (kDebugMode) {
        Get.log("The url ${userModel.photoUrl}");
      }

      _updateUserFirestore(userModel);
      pinTextController.clear();
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
    //hideLoadingIndicator();
  }

  Future updateUserProfile() async {
    Get.log("updateUserProfile");
    try {
      showLoadingIndicator();

      UserModel userModel = userFirestore!.updateImmutable(
        name: nameController.text.trim(),
        username: usernameController.text.trim(),
        about: aboutController.text.trim(),
        country: country ?? CountryCodes.detailsForLocale().name!,
        countryCode: countryCode ?? CountryCodes.detailsForLocale().dialCode!,
        address: addressController.text.trim(),
        number: numberController.text.trim(),
      );

      if (userModel.about != "" &&
          userModel.number != "" &&
          userModel.address != "") {
        await AchievementController.to.profileIsCompleted();
      }

      if (kDebugMode) {
        Get.log("The url ${userModel.photoUrl}");
      }
      _updateUserFirestore(userModel);
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
    hideLoadingIndicator();
  }

  Future<void> setUserVerificationApplied(File image) async {
    Get.log("setUserVerificationApplied");
    try {
      showLoadingIndicator();
      Reference reference =
          _storage.ref().child("verfication_image${_firebaseUser.value!.uid}");
      UploadTask uploadTask = reference.putFile(image);
      await uploadTask.whenComplete(() async {
        verificationRequest.imageUrl = await reference.getDownloadURL();
        if (kDebugMode) {
          Get.log("The url ${verificationRequest.imageUrl!}");
        }
      });
      assert(verificationRequest.imageUrl != null);

      UserModel userModel =
          userFirestore!.updateImmutable(appliedForVerification: true);

      _updateUserFirestore(userModel);
      _createVerificationRequestFirestore(
          verificationRequest, _firebaseUser.value!);
      hideLoadingIndicator();
    } catch (e) {
      Get.log(
        e.toString(),
        isError: true,
      );
      hideLoadingIndicator();
    }
  }

  //updates the firestore user in users collection
  Future _updateUserFirestore(UserModel user) async {
    Get.log("_updateUserFirestore");
    await _db.doc('/users/${user.uid}').update(user.toJson());
    update();
  }

  Future updateFCMToken() async {
    String fcmToken = MessagingService.fcmToken ?? '';
    var data = {'fcm_token': fcmToken};
    Get.log("_updateFCMToken");
    Get.log(data.toString());
    Get.log(userFirestore!.uid);
    await _db.doc('/users/${userFirestore?.uid}').update(data);
  }

  //create the firestore user in users collection
  Future _createUserFirestore(UserModel user, User firebaseUser) async {
    Get.log("_createUserFirestore");

    //check if referral code is valid
    if (user.userRef!.isNotEmpty) {
      UserModel? userModel = await _checkReferralCode(user.userRef ?? '');
      if (userModel != null) {
        await _updateReferralBonus(userModel.uid);
      }
    }

    await _db.doc('/users/${firebaseUser.uid}').set(user.toJson());

    update();
  }

  Future _createVerificationRequestFirestore(
      VerificationRequestModel verificationRequestModel,
      User firebaseUser) async {
    Get.log("_createVerificationRequestFirestore");
    await _db
        .doc('/verificationRequest/${firebaseUser.uid}')
        .set(verificationRequestModel.toJson());
    update();
  }

  //password reset email
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    Get.log("sendPasswordResetEmail");
    showLoadingIndicator();
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      hideLoadingIndicator();
      Get.snackbar(
          'auth.resetPasswordNoticeTitle'.tr, 'auth.resetPasswordNotice'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on FirebaseAuthException catch (error) {
      hideLoadingIndicator();
      Get.snackbar('auth.resetPasswordFailed'.tr, error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //check if user is an admin user
  Future isAdmin() async {
    Get.log("isAdmin");
    await getUser.then((user) async {
      DocumentSnapshot adminRef =
          await _db.collection('admin').doc(user?.uid).get();
      if (adminRef.exists) {
        admin.value = true;
      } else {
        admin.value = false;
      }
      update();
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    aboutController.dispose();
    numberController.dispose();
    addressController.dispose();
    emailController.dispose();
    pinTextController.dispose();
    oldPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    confirmEmailController.dispose();
    phoneNumberController.dispose();
    !_eventsController.isClosed ? _eventsController.dispose() : null;
    Get.log("Authcontroller onClose");
    super.onClose();
  }

  // Sign out
  Future<void> signOut() async {
    Get.log("signOut");
    usernameController.clear();
    nameController.clear();
    emailController.clear();
    pinTextController.clear();
    passwordController.clear();
    aboutController.clear();
    numberController.clear();
    addressController.clear();
    oldPasswordController.clear();
    confirmPasswordController.clear();
    confirmEmailController.clear();
    phoneNumberController.clear();
    EventsController.to.userFilteredAmount.value = null;
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    }
    return _auth.signOut();
  }

  Future<UserModel?> _checkReferralCode(String refId) async {
    try {
      UserModel? foundUserModel;
      Get.log("_checkReferralCode");

      QuerySnapshot querySnapshot = await _db.collection('/users/').get();

      for (var element in querySnapshot.docs) {
        if (element['uid']
                .toString()
                .substring(element['uid'].toString().length - 5,
                    element['uid'].toString().length)
                .toLowerCase() ==
            refId.toLowerCase()) {
          // Use data() to get the map representation of the document
          var userDataMap = element.data() as Map<String, dynamic>;
          foundUserModel = UserModel.fromMap(userDataMap);
          break;
        }
      }

      return foundUserModel;
    } catch (e) {
      print('Error while checking referral code: $e');
      return null; // or throw an error, depending on your needs
    }
  }

  Future<void> _updateReferralBonus(String? uid) async {
    QuerySnapshot querySnapshot = await _db
        .collection('referral_bonuses')
        .where("userId", isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      int amount = querySnapshot.docs[0]['amount'];
      int referralCount = querySnapshot.docs[0]['referralCount'];

      Map<String, dynamic> updateReferralData = {
        'amount': amount + 50,
        'isWithdrawable': false,
        'referralCount': referralCount + 1,
        'userId': uid
      };

      await _db
          .collection("referral_bonuses")
          .doc(querySnapshot.docs[0].id)
          .update(updateReferralData);
    } else {
      final CollectionReference<Map<String, dynamic>> collectionReference =
          _db.collection('referral_bonuses');

      Map<String, dynamic> addReferralData = {
        'amount': 50,
        'isWithdrawable': false,
        'referralCount': 1,
        'userId': uid
      };
      collectionReference.add(addReferralData).then((value) {
        print("Data added successfully! Document ID: ${value.id}");
      }).catchError((error) {
        print("Error adding data: $error");
      });
    }

    TransactionModel transactionModel =
        _walletContoller.generateTransactionHistory(
            walletAction: WalletActions.Receive,
            amount: "50",
            account: "",
            concerned: "Referral");

    await _walletContoller.incrementInAppAmountByReferral(
        50, transactionModel, uid!);
  }

  Future<void> initiateTikTokAuth() async {
    try {
      final result = await FlutterWebAuth.authenticate(
        url: 'https://open-api.tiktok.com/platform/oauth/connect/',
        callbackUrlScheme: 'your_callback_scheme',
      );

      if (result != null) {
        // await _auth.signInWithCredential(credential);
        if (referralCodeController.text.isNotEmpty) {
          UserModel? userModel =
              await _checkReferralCode(referralCodeController.text);
          if (userModel != null) {
            await _updateReferralBonus(userModel.uid);
          }
        }
      }
    } catch (e) {
      // Handle any authentication errors
    }
  }

  getLoginTikTok() async {
    // var code = await TiktokLoginFlutter.authorize(
    //     "user.info.basic,video.list,video.upload");
    // debugPrint(code);
  }

  otpSend(Function isLoading) async {
    Get.log("signInWithPhoneNumber");
    isLoading(true);
    await showLoader(() async {
      firstTimeUser = false;
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber:
              "+${countryCodeController.text}${phoneNumberController.text}",
          verificationCompleted: (PhoneAuthCredential credential) {
            isLoading(false);
          },
          verificationFailed: (FirebaseAuthException e) {
            isLoading(false);
            print(e);
            Get.snackbar('auth.signInWithPhoneError'.tr, e.message.toString(),
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 7),
                backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                colorText: Get.theme.snackBarTheme.actionTextColor);
          },
          codeSent: (String verificationId, int? resendToken) {
            print(verificationId);
            this.verificationId = verificationId;
            isLoading(false);
            Get.to(() => const OtpScreenForPhone());
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            isLoading(false);
            print(verificationId);
          },
        );
      } catch (e) {
        isLoading(false);
        Get.snackbar('auth.signInWithPhoneError'.tr, e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 7),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      }
    });
  }

  verifyOtp() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    print("verificationId");
    print(verificationId);
    print("smsCode");
    print(smsCode);
    await showLoader(() async {
      firstTimeUser = false;
      try {
        await _auth.signInWithCredential(credential);
        if (referralCodeController.text.isNotEmpty) {
          UserModel? userModel =
              await _checkReferralCode(referralCodeController.text);
          if (userModel != null) {
            await _updateReferralBonus(userModel.uid);
          }
        }
      } catch (e) {
        Get.snackbar(
            'auth.signInWithPhoneError'.tr, 'auth.signInWithPhoneError'.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 7),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      }
      update();
    });
  }

  //
}
