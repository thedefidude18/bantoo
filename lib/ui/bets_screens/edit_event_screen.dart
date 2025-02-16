import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/wallet_controller.dart';
import '../components/custom_button.dart';
import '../notifications_and_bethistory/notifications.dart';
import '../wallet/wallet.dart';
import 'bets_screen.dart';
import 'my_bet_history_screen.dart';


class EditEventScreen extends StatefulWidget {


  // Accept the notification type from NotificationsScreen
  const EditEventScreen({super.key});
  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {


  late String _notificationTypeIcon;

  @override
  void initState() {
    super.initState();

  }

  // Map notification types to specific icons

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: IconThemeData(color: ColorConstant.whiteA700),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => NotificationsScreen());
                }, icon: Image.asset(ImageConstant.search2,height: 38,width: 38,),),

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
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      const Tab(text: 'My Events'),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        height: 25,
                        width: 30,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                            child: Text(
                              "1",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 25,
                        width: 30,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                              "1",
                              style: TextStyle(color: ColorConstant.whiteA700),
                            )),
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                      const Tab(text: 'Participants'),
                      Image.asset(ImageConstant.group,height: 60,width: 45,),
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
          Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: ColorConstant.listBackground),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52.69,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: ColorConstant.gray2),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Title of your Event",
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            labelStyle: TextStyle(
                                color: ColorConstant.labelColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Popins"),
                          suffixIcon: Image.asset(ImageConstant.editIcon2, )
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 105,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: ColorConstant.gray2),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Describe your Event",
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            labelStyle: TextStyle(
                                color: ColorConstant.labelColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Popins"),
                            suffixIcon: Image.asset(ImageConstant.editIcon2, )
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Pick an event category",
                    style: TextStyle(
                        color: ColorConstant.labelColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Popins"),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 9,
                        width: 114,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        height: 9,
                        width: 114,
                        decoration: BoxDecoration(
                            color: ColorConstant.black900,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        height: 9,
                        width: 114,
                        decoration: BoxDecoration(
                            color: ColorConstant.black900,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    height: 173,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3, // Set the number of items here
                        itemBuilder: (context, index) {
                          return Stack(children: [
                            Container(
                              width: 177,
                              // Adjust the width of each item
                              margin:
                              const EdgeInsets.symmetric(horizontal: 1.0),
                              // Adjust margin between items
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: ColorConstant
                                      .primaryColor // You can set different colors for each item if needed
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset((ImageConstant.party),width: 50,height: 50,),
                                    const Text(
                                      "Party",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Popins",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      "50,000 Events",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Popins",
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                right: 12,
                                top: 145,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.whiteA700,
                                      borderRadius: BorderRadius.circular(30)),
                                ))
                          ]);
                        }),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 52.69,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: ColorConstant.gray2),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Event Duration",
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelStyle: TextStyle(
                                  color: ColorConstant.labelColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Popins",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 80), // Add space between dropdowns
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Month",
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelStyle: TextStyle(
                                  color: ColorConstant.labelColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Popins",
                                ),
                              ),
                              icon: const Icon(Icons.arrow_drop_up_outlined),
                              items: [
                                "Type A",
                                "Type B",
                                "Type C"
                              ] // Add your dropdown items here
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                // Handle dropdown value change here
                              },
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Year",
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelStyle: TextStyle(
                                  color: ColorConstant.labelColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Popins",
                                ),
                              ),
                              items: [
                                "Type A",
                                "Type B",
                                "Type C"
                              ] // Add your dropdown items here
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                // Handle dropdown value change here
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52.69,
                          width: MediaQuery.of(context).size.width/2,
                          decoration: BoxDecoration(color: ColorConstant.gray2),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText:
                                  "Max number of Participants that can join your event.",
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  labelStyle: TextStyle(
                                      color: ColorConstant.labelColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Popins")),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Container(
                          height: 52.69,
                          width: MediaQuery.of(context).size.width/2,
                          decoration: BoxDecoration(color: ColorConstant.gray2),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText:
                                  "Event Visibility",
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  labelStyle: TextStyle(
                                      color: ColorConstant.labelColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Popins")),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 52.69,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: ColorConstant.gray2),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Event cover Image",
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            labelStyle: TextStyle(
                                color: ColorConstant.labelColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Popins")),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 52.69,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: ColorConstant.gray2),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Events Rules",
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            labelStyle: TextStyle(
                                color: ColorConstant.labelColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Popins")),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: CustomButton(
                      text: "Save",
                      fontStyle: ButtonFontStyle.PoppinsBold18,
                      height: 48,
                      width: 307,
                      onTap: () {
                        _showSuccessPopup(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: ColorConstant.listBackground
                ),
                child: ListView.builder(
                  itemCount: 6, // Replace 'itemCount' with the actual number of items
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          height: 125,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: ColorConstant.whiteA700,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(ImageConstant.beach),
                                    Text(
                                      "Peter will run faster than Mike....",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Popins",
                                        color: ColorConstant.textColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    Image.asset(ImageConstant.history),
                                    Text(
                                      "09:30:54",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Popins",
                                        color: ColorConstant.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                  width: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(ImageConstant.profile1,width: 50,height: 50,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "@logosboy23",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Popins",
                                            fontWeight: FontWeight.w500,
                                            color: ColorConstant.red300,
                                          ),
                                        ),
                                        Text(
                                          "Picked Yes",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Popins",
                                            fontWeight: FontWeight.w500,
                                            color: ColorConstant.textColor,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 70,
                                    ),
                                    const CustomButton(
                                      height: 50,
                                      width: 140,
                                      text: "Accept Request",
                                      fontStyle: ButtonFontStyle.PoppinsSemiBold14WhiteA700,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    );
                  },
                )


              )],
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
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      barrierColor: ColorConstant.black900.withOpacity(0.87),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.only(top: 100),
          content: Column(
            children: [
              Container(
                height: 325,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Congratulations!",
                      style: TextStyle(
                          color: ColorConstant.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Popins"),
                    ),
                    Image.asset(ImageConstant.successHappy,height: 150,width: 150,),
                    Text(
                      "You have successfully updated your event.\nPlease kindly share your event link and \n            invite your friends to join.",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Popons",
                          color: ColorConstant.black900),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Share",
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Popons",
                              color: ColorConstant.black900),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Image.asset(ImageConstant.whatsapp,height: 30,width: 30,),
                        const SizedBox(
                          width: 16,
                        ),
                        Image.asset(ImageConstant.faceBookLogo,height: 30,width: 30,),
                        const SizedBox(
                          width: 16,
                        ),
                        Image.asset(ImageConstant.twitter,height: 30,width: 30,), const SizedBox(
                          width: 16,
                        ),
                        Image.asset(ImageConstant.shareIcon,height: 30,width: 30,),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: "Proceed to your created bets.",
                fontStyle: ButtonFontStyle.PoppinsSemiBold18,
                height: 48,
                width: 307,
                onTap: () {
                  Get.to(const MyBetHistoryScreen());
                },
              )
            ],
          ),
        );
      },
    );
  }
}
