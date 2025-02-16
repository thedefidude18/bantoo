import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/chat/widgets/notifiactionIcon.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/helpers/validator.dart';
import 'package:flexx_bet/models/user_model.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/form_input_field.dart';
import 'package:flexx_bet/ui/components/form_vertical_spacing.dart';
import 'package:flexx_bet/ui/private%20chat%20user/private_chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../models/UserDetailModel.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool hasError = false;

  late bool _passwordVisible;
  late bool _confirmPasswordVisible;
  late bool _oldPasswordVisible;
  bool isFriend = false;
  int unreadCount = 0;
  String _generateChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  void getFriendsUnreadChatList() async {
    setState(() {
      isFriend = true;
    });

    final FirebaseFirestore _db = FirebaseFirestore.instance;
    AuthController authController = AuthController.to;
    final UserModel userModel = authController.userFirestore!;
    final String userId = userModel.uid;

    _db.collection('friend_requests').snapshots().listen((snapshot) async {
      for (var document in snapshot.docs) {
        var data = document.data();
        var from = data['from'];
        var to = data['to'];
        if (from == userId || to == userId) {
          String friendUid = from == userId ? to : from;

          // Fetch friend's user details
          DocumentSnapshot<Map<String, dynamic>> friendSnapshot =
              await _db.collection('users').doc(friendUid).get();
          UserDetailModel friendData =
              UserDetailModel.fromMap(friendSnapshot.data()!);

          // Fetch latest message in the chat
          String chatId = _generateChatId(from, to);
          QuerySnapshot messageSnapshot = await _db
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .limit(1)
              .get();

          unreadCount = messageSnapshot.docs
              .where((doc) => !doc['isRead'] && doc['senderUid'] != userId)
              .length;
          print("UnReadCont::${unreadCount}");
        }
      }

      // setState(() {
      isFriend = false;
      // });
    });
  }

  @override
  void initState() {
    getFriendsUnreadChatList();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    _oldPasswordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    authController.pinTextController.clear();
    authController.passwordController.clear();
    authController.oldPasswordController.clear();
    authController.confirmPasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ColorConstant.whiteA700,
        centerTitle: true,
        title: Text(
          "Change Password",
          // style: TextStyle(color: ColorConstant.black900),
        ),
        leading: BackButton(
          color: ColorConstant.whiteA700,
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          InkWell(
              onTap: () {
                Get.to(
                  () => PrivateChatUserScreen(),
                );
              },
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      ImageConstant.headerLogo,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    unreadCount.toString(),
                  ),
                ),
              )),
          const NotificationIcon(
            defaultType: 'messages',
            iconPaths: {
              'messages': 'assets/images/messagenoti.png',
              'request': 'assets/images/requestnoti.png',
              'Generation': 'assets/images/notification_new.png',
            },
            fallbackIcon: Icons.notifications, // Fallback icon
          ),
        ],
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
                  height: 20,
                ),
                const FormVerticalSpace(),
                FormInputField(
                  controller: authController.oldPasswordController,
                  labelText: 'auth.oldPasswordFormField'.tr,
                  validator: Validator().password,
                  obscureText: !_oldPasswordVisible,
                  onChanged: (value) {},
                  onSaved: (value) =>
                      authController.passwordController.text = value!,
                  suffixWidget: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _oldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black45,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _oldPasswordVisible = !_oldPasswordVisible;
                      });
                    },
                  ),
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
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  "Enter Pin to confirm new Password",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PinCodeTextField(
                    appContext: context,
                    autoDisposeControllers: false,
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    controller: authController.pinTextController,
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
                    onChanged: (value) {},
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
                      await authController.updateUserPassword();
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
