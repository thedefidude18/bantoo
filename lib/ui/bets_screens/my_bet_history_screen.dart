import 'package:flexx_bet/chat/widgets/notifiactionIcon.dart';
import 'package:flexx_bet/ui/bets_screens/edit_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/wallet_controller.dart';
import '../components/custom_button.dart';
import '../notifications_and_bethistory/notifications.dart';
import '../wallet/wallet.dart';
import 'bets_screen.dart';
import 'create_bet_screen.dart';
import 'created_bet_history.dart';


class MyBetHistoryScreen extends StatefulWidget {
  const MyBetHistoryScreen({super.key});

  @override
  State<MyBetHistoryScreen> createState() => _MyBetHistoryScreenState();
}

class _MyBetHistoryScreenState extends State<MyBetHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: IconThemeData(color: ColorConstant.whiteA700),
          actions: [
            Stack(
              children: [
                InkWell(
                  onTap: (){
                    _showPopup(context);
                  },
                  child: Container(
                    height: 30,
                    width: 125,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [ColorConstant.deepPurpleA200,ColorConstant.orange]
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(18),bottomRight: Radius.elliptical(50,70))

                    ),
                    child: Center(child:  Text("Create A Event",style: TextStyle(color: ColorConstant.whiteA700,fontFamily: "Popins",fontWeight: FontWeight.w600,fontSize: 16),)),
                  ),
                ),
                Positioned(
                  left: 6,
                    top: 2,
                    child: SvgPicture.asset(ImageConstant.starIcon))
              ],
            ),
            const SizedBox(
              width: 12,
            ),
            const NotificationIcon(
              defaultType: 'messages',
              iconPaths: {
                'messages': 'assets/images/messagenoti.png',
                'request': 'assets/images/requestnoti.png',
                'Generation': 'assets/images/notification_new.png',
              },
              fallbackIcon: Icons.notifications, // Fallback icon


            ),
            const SizedBox(
              width: 6,
            ),

            GestureDetector(
              onTap: () {
                Get.to(() => WalletScreen());
              },
              child: Container(
                height: 35,
                width: 97,
                margin: const EdgeInsets.only(top: 14, bottom: 14),
                padding: const EdgeInsets.only(left: 18, right: 18),
                decoration: BoxDecoration(
                    color: ColorConstant.whiteA700,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
                child: Center(
                  child: GetBuilder<WalletContoller>(builder: (controller) {
                    return Text(
                      "₦${controller.totalAmount}",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.primaryColor),
                    );
                  }),
                ),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.square(50),
            child: Material(
              color: Colors.white,
              elevation: 0,
              child: TabBar(
                tabs: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Tab(text: 'Public Events'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                            color: ColorConstant.green1,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                            child: Text(
                              "60",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Tab(text: 'My Events'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                              "1",
                              style: TextStyle(color: ColorConstant.whiteA700),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No event Created Yet!',
                      style: TextStyle(
                          color: ColorConstant.blueGray40002,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Popins")),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "Create a Event",
                    fontStyle: ButtonFontStyle.PoppinsSemiBold18,
                    height: 48,
                    width: 307,
                    onTap: () {
                      Get.to( CreatedBetHistory(""));
                    },
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('₦54,292.79',
                      style: TextStyle(
                          color: ColorConstant.black1,
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Popins")),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: (){
                      Get.to(CreateBetScreen());
                    },
                    style: ButtonStyle(
                      fixedSize: const MaterialStatePropertyAll(
                        Size (250,28)
                      ),
                      backgroundColor: MaterialStatePropertyAll(
                        ColorConstant.primaryColor
                      )
                    ),
                    child: Text("widthraw to wallet",style: TextStyle(
                      color: ColorConstant.whiteA700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Popins"
                    ),),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 225,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                    BoxDecoration(color: ColorConstant.blueGray10096,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: (){
                                  //_showPopupEvent(context);
                                },
                                child: SizedBox(
                                  height: 150,
                                  width: 90,
                                  child: Image.asset(ImageConstant.imageBet,fit: BoxFit.fill),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 1,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Peter will run faster than Mike \nat the beach today",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: "Popins"),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Beach Party",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstant.blueGray400A2,fontSize: 13,fontFamily: "Popins"),
                                        ),
                                        Image.asset(ImageConstant.beach)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Image.asset(ImageConstant.vector),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 14,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: ColorConstant.primaryColor,
                                              borderRadius:
                                              BorderRadius.circular(12)),
                                          child: const Center(
                                              child: Text(
                                                "No",
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 8,fontFamily: "Popins"),
                                              )),
                                        ),
                                        const SizedBox(
                                          width: 100,
                                        ),
                                        Container(
                                          height: 14,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: ColorConstant.greenLight,
                                              borderRadius:
                                              BorderRadius.circular(12)),
                                          child: const Center(
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 8,fontFamily: "Popins"),
                                              )),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  /*  RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: ColorConstant.blueGray400A2,
                                            fontFamily: "Popins"
                                        ),
                                        children: const <TextSpan>[
                                          TextSpan(
                                            text: 'Hosted By ',
                                          ),
                                          TextSpan(
                                            text: '@olly76',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )*/
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset(ImageConstant.group,height: 24.06,width: 90.3,),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CustomButton(
                                    height: 40,
                                    width: 70,
                                    prefixWidget: Image.asset(ImageConstant.editIcons,height: 18,width: 18,),
                                    text: "Edit",
                                    fontStyle:ButtonFontStyle.PoppinsMedium12WhiteA700,
                                    onTap: (){
                                      Get.to(const EditEventScreen());
                                    },
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(ImageConstant.history),
                                      const Text("LIVE",style: TextStyle(fontFamily: "Popins"),)
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Text('3% of total pool',
                            style: TextStyle(
                                color: ColorConstant.labelColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Popins")),
                        Text('₦54,292.79',
                            style: TextStyle(
                                color: ColorConstant.black1,
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Popins")),
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showPopup(BuildContext context) {
    showDialog(
      barrierColor: ColorConstant.black900.withOpacity(0.8),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            height: 467,
            width: 353,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Please Read Terms",
                  style: TextStyle(
                      color: ColorConstant.primaryColor, fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please read and agree to terms before you proceed.\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
                const Spacer(),
                CustomButton(
                  text: "Proceed",
                  fontStyle: ButtonFontStyle.InterSemiBold16,
                  onTap: (){
                    Get.to(const BetScreen());
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
