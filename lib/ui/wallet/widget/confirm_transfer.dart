import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/wallet_controller.dart';
import 'package:flexx_bet/ui/wallet/widget/transfer_success.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/notification_controller.dart';
import '../../../models/notification_model.dart' as model;
import '../../../models/user_model.dart';
import '../../../ui/components/custom_button.dart';
import '../../../ui/components/custom_image_view.dart';
import '../../../view_model/auth_view_model.dart';

void confirmTransfer(num amount) {
  AuthController authController = AuthController.to;
  final UserModel userModel = authController.userFirestore!;
  WalletContoller walletContoller = WalletContoller.to;
  final NotificationController notificationController =
  Get.put<NotificationController>(NotificationController());
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(300)),
          width: 100,
          height: 100,
          child: Material(
            borderRadius: BorderRadius.circular(300),
            child: CustomImageView(
              imagePath: ImageConstant.walletConfirmationImage,
              width: 50,
            ),
          ),
        ),
        MyArc(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "Transfer Confirmation",
                style:
                    TextStyle(color: ColorConstant.primaryColor, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "From",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          authController.userFirestore!.username,
                          style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          authController.userFirestore!.photoUrl),
                      radius: 30,
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                color: Colors.grey,
                height: .21,
                width: Get.width,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "To",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          authController.otherUser!.username,
                          style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          authController.otherUser!.photoUrl),
                      radius: 30,
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                color: Colors.grey,
                height: .21,
                width: Get.width,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                          color: ColorConstant.gray600,
                          fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Text(
                          "₦$amount",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "0% fee",
                          style: TextStyle(
                            color: ColorConstant.primaryColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              CustomButton(
                width: Get.width,
                text: "OK, Send Now!",
                fontStyle: ButtonFontStyle.PoppinsMedium16,
                padding: ButtonPadding.PaddingAll4,
                height: 50,
                onTap: () async {

                  await walletContoller.transferMoney(amount);
                  Get.back();
                  awesomeNotifications.createNotification(
                      content: NotificationContent(
                        id: 10,
                        channelKey: 'basic_channel',
                        actionType: ActionType.Default,
                        title: 'Money Transfer',
                        body:
                        'You have successfully transfered money ₦${amount} to  ${authController.otherUser!.name}',
                      ));

                 model.NotificationModel  notificationModel = model.NotificationModel(
                      userId: userModel.uid,
                      body: 'You have successfully transfered money  ₦${amount} to  ${authController.otherUser!.name}',
                      type: "Money Transfered",
                      creationDate: DateTime.now(),
                   title:  "Transfer Success",
                   amount: "",
                   selectedOption: "",
                   eventId: ""
                  );
                  await notificationController.addNotification(notificationModel);
                  getUserToken(authController.otherUser!.uid);
                  transferSuccess(amount, authController.otherUser!.username);
                },
              )
            ],
          ),
        ),
      ],
    ),
  );

}

getUserToken(String uid) async {
  FirebaseFirestore.instance.doc('/users/$uid').get().then((value){
    if(value['fcm_token'] != null){
      sendNotification("Amount received", "You received amount", value['fcm_token']);
    }
  });
}

sendNotification(String title, String body,String token){
  final authViewModel= AuthViewModel();
  var data = {
    "notification":{
      "title": title,
      "body":body,
    },
    "token":token,
  };
  authViewModel.pushNotification(data);
}

class MyArc extends StatelessWidget {
  final Widget child;
  const MyArc({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 1.2,
      height: Get.height / 1.9,
      child: CustomPaint(
        painter: CurvePainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 45, 8, 8),
          child: Material(color: Colors.white, child: child),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 20);
    path.quadraticBezierTo(size.width, 00, size.width - 20, 0);
    path.lineTo(size.width - 100, 0);
    path.quadraticBezierTo(size.width / 2, size.height / 6, 100, 0);
    path.lineTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
