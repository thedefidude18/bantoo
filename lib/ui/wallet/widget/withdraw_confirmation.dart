import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/bank_controller.dart';
import 'package:flexx_bet/ui/components/loader.dart';
import 'package:flexx_bet/ui/wallet/widget/withdraw_success.dart';
import 'package:flexx_bet/ui/wallet/withdraw_to.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/notification_controller.dart';
import '../../../models/notification_model.dart' as model;
import '../../../models/user_model.dart';
import '../../../ui/components/custom_button.dart';
import '../../../ui/components/custom_image_view.dart';

void withdrawConfirmation() {
  AuthController authController = AuthController.to;
  final UserModel userModel = authController.userFirestore!;
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
              Text(
                "Withdraw Confirmation",
                style:
                    TextStyle(color: ColorConstant.primaryColor, fontSize: 20),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("From"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          authController.userFirestore!.username,
                          style: TextStyle(
                            color: ColorConstant.primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Bantah",
                          style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const CircleAvatar(
                      backgroundImage: AssetImage(ImageConstant.user2),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'To ${banksController.currentSelectedBank.value!["name"]}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Account Number",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          banksController.account,
                          style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const CircleAvatar(
                      backgroundImage: AssetImage(ImageConstant.user2),
                      radius: 30,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 70, child: Text("Name")),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          authController.userFirestore!.name,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 80,
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
                          "${BanksController.to.amount}",
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
                  await showLoader(() async {
                    await banksController.initiateWithdraw();
                  });
                  if (banksController.isError == false &&
                      banksController.transferSuccessful) {
                    Get.back();
                    awesomeNotifications.createNotification(
                        content: NotificationContent(
                          id: 10,
                          channelKey: 'basic_channel',
                          actionType: ActionType.Default,
                          title: 'Money Withdraw',
                          body:
                          'You have successfully withdraw money ${BanksController.to.amount}',
                        ));
                    model.NotificationModel notificationModel = model.NotificationModel(
                        userId: userModel.uid,
                        body: 'You have successfully withdraw money ${BanksController.to.amount}',
                        type: "Money withdraw",
                        creationDate: DateTime.now(),
                      title: "Amount Withdraw",
                      amount: "",
                      selectedOption: "",
                      eventId: ""
                    );
                    await notificationController.addNotification(notificationModel);
                    withdrawSuccess(BanksController.to.amount);
                  } else {
                    Get.back();
                    Get.showSnackbar(const GetSnackBar(
                      title: "There was error withdrawing",
                      message: "Sorry for inconvineince",
                      duration: Duration(seconds: 1),
                    ));
                  }
                },
              )
            ],
          ),
        ),
      ],
    ),
  );
}

class MyArc extends StatelessWidget {
  final Widget child;
  const MyArc({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 1.2,
      height: Get.height / 1.8,
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
