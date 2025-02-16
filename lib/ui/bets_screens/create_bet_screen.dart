import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/chat_service.dart';
import 'package:flexx_bet/chat/widgets/dashed_border.dart';
import 'package:flexx_bet/chat/widgets/notifiactionIcon.dart';
import 'package:flexx_bet/chat/widgets/terms_conditions_widget.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/utils/bet_styles.dart';
import 'package:flexx_bet/utils/date_utils.dart';
import 'package:flexx_bet/utils/file_utils.dart';
import 'package:flexx_bet/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/wallet_controller.dart';
import '../notifications_and_bethistory/notifications.dart';
import '../wallet/wallet.dart';

class CreateBetScreen extends StatefulWidget {
  CreateBetScreen({super.key});

  @override
  State<CreateBetScreen> createState() => _CreateBetScreenState();
}

class _CreateBetScreenState extends State<CreateBetScreen> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  late bool creatorPaid;
  var durationController = TextEditingController();
  var eventStartController = TextEditingController();
  Map? selectedCategory;
  DateTime? selectedDateTime;
  DateTime? selectedStartDateTime;
  var limitController = TextEditingController();
  var imageController = TextEditingController();
  var rulesController = TextEditingController();
  var groupBetJoinAmount = TextEditingController();
  String? visibility;
  String? groupId;
  String? image;
  var controller = Get.put(ChatController(uid: FirebaseAuth.instance.currentUser?.uid ?? ""));
  var walletController = Get.find<WalletContoller>();
  var isUpdate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<dynamic> categoriesNewList = [
    {
      "name":"Games",
      "category": "game",
      "imagePath": ImageConstant.gamepadImage,
      "gradiant":[Color(0xff7440FF), Color(0xff04010E)]
    },
    {
      "name":"Sports",
      "category": "sports",
      "imagePath": ImageConstant.categorySportsImage,
      "gradiant":[Color(0xff1B24FF), Color(0xff04010E)]
    },{
      "name":"Music",
      "category": "music",
      "imagePath": ImageConstant.djSetup,
      "gradiant":[Color(0xff34C759), Color(0xffFD495E)]
    },
    {
      "name":"Crypto",
      "category": "crypto",
      "imagePath": ImageConstant.bitCoinImage,
      "gradiant":[Color(0xffFF9900), Color(0xff7440FF)]
    },
    {
      "name":"Movies/TV",
      "category": "movies/tv",
      "imagePath": ImageConstant.popCornBoxImage,
      "gradiant":[Color(0xffFF2C2C), Color(0xff080742)]
    },
    {
      "name":"Pop Culture",
      "category": "pop culture",
      "imagePath": ImageConstant.popCultureImage,
      "gradiant":[Color(0xff6B0CFF), Color(0xff266939)]
    },
    {
      "name":"Forex",
      "category": "forex",
      "imagePath": ImageConstant.forex,
      "gradiant":[Color(0xff00A3FF), Color(0xff64EA25)]
    },
    {
      "name":"Politics",
      "category": "politics",
      "imagePath": ImageConstant.politicsImage,
      "gradiant":[Color(0xffFFBF66), Color(0xff7440FF)]
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = categoriesNewList.first;
    controller.groupBannerImage.value = null;

    if (Get.arguments is Map) {
      try {
        var data = Get.arguments as Map;
        titleController.text = data.getValueOfKey("groupName") ?? "";
        groupId = data.getValueOfKey("groupId") ?? "";
        image = (data.getValueOfKey("groupIcon") == "")? null :data.getValueOfKey("groupIcon");
        descriptionController.text = data.getValueOfKey("description") ?? "";
         creatorPaid = data.getValueOfKey('creatorPaid')?? false;
        limitController.text = "${data.getValueOfKey("membersLimit") ?? ""}";
        rulesController.text = data.getValueOfKey("rules") ?? "";
        visibility = data.getValueOfKey("groupType") ?? "";
        if(data.getValueOfKey("endAt")!=null){
          selectedDateTime = DateTime.fromMicrosecondsSinceEpoch(data.getValueOfKey("endAt") ?? DateTime.now().millisecondsSinceEpoch);
          durationController.text = DateTimeUtils.formattedDate(date: selectedDateTime,dateFormat: DateTimeUtils.chatDateFormat);
        }
        if(data.getValueOfKey("category")!=null){
          var cat = categoriesNewList.where((element){
            return (element is Map) &&  element["name"] == data.getValueOfKey("category");
          }).toList();
          if(cat.isNotEmpty){
            selectedCategory = cat.first;
          }
        }
        isUpdate = true;
      } catch (e) {
        "Exception--------->$e";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: IconThemeData(color: ColorConstant.whiteA700),
          actions: [
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
              width: 12,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => WalletScreen());
              },
              child: Container(
                height: 37,
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
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: ColorConstant.listBackground),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   height: 52.69,
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(color: ColorConstant.gray2),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 16),
                    //     child: TextFormField(
                    //       controller: titleController,
                    //       decoration: InputDecoration(
                    //           labelText: "Title of your Event",
                    //           border: const UnderlineInputBorder(
                    //               borderSide: BorderSide.none),
                    //           labelStyle: TextStyle(
                    //               color: ColorConstant.labelColor,
                    //               fontSize: 13,
                    //               fontWeight: FontWeight.w500,
                    //               fontFamily: "Popins")),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    Container(
                      height: 105,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: ColorConstant.gray2),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          controller: descriptionController,
                          decoration: InputDecoration(
                              labelText: "Describe your Event",
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
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:categoriesNewList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap:(){
                                setState(() {
                                  selectedCategory = categoriesNewList[index];
                                });
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                  children: [
                                Container(
                                  width: 177,
                                  height: 173,
                                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                     color: ColorConstant.primaryColor
                                  ),
                                  child: Padding(
                                    padding:  const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset( categoriesNewList[index]['imagePath'],height: 50,width: 50,),
                                        Text(
                                          categoriesNewList[index]['name'],
                                          style: const TextStyle(
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
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: selectedCategory == categoriesNewList[index] ?ColorConstant.green2:ColorConstant.whiteA700,
                                      borderRadius: BorderRadius.circular(30)),
                                )
                              ]),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: ColorConstant.gray2),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter event start date';
                                  }
                                  return null;
                                },
                                controller:eventStartController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Event start date",
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
                                onTap: (){
                                  _selectDate(context).then((dateResult){
                                    _selectTime(context).then((timeResult) {
                                      var result =  DateTimeUtils.mergeDateAndTime(dateResult,timeResult);
                                      eventStartController.text = DateTimeUtils.formattedDate(date: result,dateFormat: DateTimeUtils.chatDateFormat);
                                      selectedStartDateTime = result;
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: ColorConstant.gray2),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter event end date';
                                  }
                                  return null;
                                },
                                controller:durationController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Event end date",
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
                                onTap: (){
                                  _selectDate(context).then((dateResult){
                                    _selectTime(context).then((timeResult) {
                                      var result =  DateTimeUtils.mergeDateAndTime(dateResult,timeResult);
                                      durationController.text = DateTimeUtils.formattedDate(date: result,dateFormat: DateTimeUtils.chatDateFormat);
                                      selectedDateTime = result;
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: ColorConstant.gray2),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Event join amount';
                                  }
                                  return null;
                                },
                                controller: groupBetJoinAmount,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                decoration: InputDecoration(
                                    labelText:
                                    "Event join amount",
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
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: ColorConstant.gray2),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the maximum number of participants';
                                  }
                                  return null;
                                },
                                controller: limitController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                decoration: InputDecoration(
                                    labelText:
                                        "Max participants",
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
                      decoration: BoxDecoration(color: ColorConstant.gray2),
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select visibility';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: " Visibility",
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
                          GroupType.public.name,
                          GroupType.private.name,
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: visibility,
                        onChanged: (String? value) {
                          visibility = value;
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: ColorConstant.gray2),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the event rules';
                            }
                            return null;
                          },
                          controller: rulesController,
                          maxLines: 5,
                          decoration: InputDecoration(
                              labelText: "Events Rules",
                              border: const UnderlineInputBorder(borderSide: BorderSide.none),
                              labelStyle: TextStyle(
                                  color: ColorConstant.labelColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Popins")),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      height: 150,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: ColorConstant.whiteA700,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: ColorConstant.borderColor),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Obx(() {
                            return (controller.groupBannerImage.value != null)
                                ?Image.network(
                              "${FileImage(controller.groupBannerImage.value!)}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                 "${FileImage(controller.groupBannerImage.value!)}", // Your fallback image
                                  fit: BoxFit.cover,

                                );
                              },
                            )
                            // FadeInImage(
                            //   image: FileImage(controller.groupBannerImage.value!),
                            //   placeholder: FileImage(controller.groupBannerImage.value!),
                            //   fit: BoxFit.cover,
                            // )
                                :Container();
                          }
                          ),
                          DashedRect(
                            color: ColorConstant.gray,
                            strokeWidth: 1.0,
                            gap: 5.0,
                          ),
                          Opacity(
                            opacity: 0.5,
                            child: GestureDetector(
                              onTap: (){
                                showAlertDialog(
                                    titleText: 'Choose an option',
                                    infoText:
                                    "choose one of the option from following to continue",
                                    extraDetails: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              FileUtils.getImageFromCamera()
                                                  .then((value) async {
                                                if (value != null) {
                                                  controller.groupBannerImage
                                                      .value = value;
                                                  Get.back();
                                                  // var url = await controller
                                                  //     .uploadChatImage(
                                                  //     context: context,
                                                  //     groupId: controller.currentGroup.value?.id ?? "",
                                                  //     prefix: "banner",
                                                  //     image: value);
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              ImageConstant.iconCamera,
                                              height: 60.0,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 40.0,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              FileUtils.getImageFromGallery()
                                                  .then((value) async {
                                                if (value != null) {
                                                  controller.groupBannerImage
                                                      .value = value;
                                                  Get.back();
                                                  // var url = await controller
                                                  //     .uploadChatImage(
                                                  //     context: context,
                                                  //     groupId: controller.currentGroup.value?.id ?? "",
                                                  //     prefix: "banner",
                                                  //     image: value);
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              ImageConstant.iconGallery,
                                              height: 60.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              },
                              child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(ImageConstant.image_share_icon,height: 50.0,width: 50.0,),
                                      RichText(
                                          text: TextSpan(
                                            style: FlexxBetStyles.textStyle,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "Click to upload your event banner.",
                                                style: FlexxBetStyles.textStyle
                                                    .copyWith(fontSize: 14,color: ColorConstant.primaryColor),
                                              ),

                                            ],
                                          )),
                                      Text("(Max. File size: 2MB)",style: FlexxBetStyles.textStyle.copyWith(fontSize: 14,color: ColorConstant.black),)
                                    ],
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Checkbox(
                              value: controller.termsConditionsAccepted.value,
                              onChanged: (val) {
                                if (val != null && val == false) {
                                  controller.termsConditionsAccepted.value = val;
                                } else {
                                  _showPopup(context);
                                }
                              });
                        }),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "I Accept ",
                                style: FlexxBetStyles.textStyle
                                    .copyWith(fontSize: 14),
                              ),
                              TextSpan(
                                  text: "Terms Conditions",
                                  style: FlexxBetStyles.textStyle.copyWith(
                                      fontSize: 14,
                                      color: ColorConstant.primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _showPopup(context);
                                    })
                            ],
                          )),
                        ),
                      ],
                    ),
                    Center(
                      child: CustomButton(
                        text: "Submit",
                        fontStyle: ButtonFontStyle.PoppinsBold18,
                        height: 48,
                        onTap: () {

                         if(_formKey.currentState!.validate()){
                           FocusScope.of(context).unfocus();
                           if(isUpdate == true && groupId!=null){
                             controller.updateGroup(
                                 context: context,
                                 groupId: groupId!,
                                 title: descriptionController.text,
                                 description: descriptionController.text,
                                 category: selectedCategory?["name"] ?? "party",
                                 startDate: selectedDateTime ?? DateTime.now(),
                                 endDate: selectedDateTime ?? DateTime.now(),
                                 maxLimit: limitController.text,
                                 joinAmount: int.parse(groupBetJoinAmount.text),
                                 creatorPaid:creatorPaid,
                                 banner: image,
                                 groupType: visibility,
                                 rules: rulesController.text).then((value){
                               _showSuccessPopup(context,isUpdate: true);
                             });
                             return;
                           }
                           controller.groupCreationEligibility(controller: walletController)
                               .then((value) {
                             if (value == false) {
                               showAlertDialog(
                                   titleText: "Group Creation failure",
                                   infoText:
                                   "You've not enough balance in your wallet. N200 balance is required to create a group. please fund your wallet & continue",
                                   buttonText: "Go to wallet",
                                   buttonTextStyle: const TextStyle(
                                       color: Colors.white,
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16),
                                   buttonBackgroundColor:
                                   ColorConstant.primaryColor,
                                   onPressed: () {
                                     Get.back(result: true);
                                   }).then((value) {
                                 if (value == true) {
                                   Get.to(() => WalletScreen());
                                 }
                               });
                             } else {
                               controller.createGroup(
                                   context: context,
                                   walletContoller: walletController ,
                                   title: descriptionController.text,
                                   description: descriptionController.text,
                                   category: selectedCategory?["name"] ?? "party",
                                   startDate: selectedStartDateTime ?? DateTime.now(),
                                   endDate: selectedDateTime ?? DateTime.now(),
                                   maxLimit: limitController.text,
                                   joinAmount: int.parse(groupBetJoinAmount.text),
                                   creatorPaid:false,
                                   // coverImage: imageController.text,
                                   groupType: visibility,
                                   rules: rulesController.text).then((value){
                                 // controller.getGroups();
                                 if(value is Map){
                                   // _showLoadingPopup(context);
                                   _showSuccessPopup(context);
                                 }
                               });
                             }
                           });
                         }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showLoadingPopup(BuildContext context) {
    showDialog(
      barrierColor: ColorConstant.black900.withOpacity(0.87),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          content: Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              color: ColorConstant.whiteA700,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Creating a new event, \n       please wait....",
                  style: TextStyle(
                      color: ColorConstant.black900,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Image.asset(ImageConstant.timer),
                const Spacer(),
                CustomButton(
                  text: "Submit",
                  fontStyle: ButtonFontStyle.InterSemiBold16,
                  onTap: () {
                    //Get.to(CreateBetScreen());
                    Navigator.pop(context);
                    _showSuccessPopup(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessPopup(BuildContext context,{bool isUpdate = false}) {
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
                      "You have successfully ${isUpdate?"updated":"created"} an event.\nPlease kindly share your event link and \n            invite your friends to join.",
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
                text: "Proceed to your ${isUpdate?"updated":"created"} bets.",
                fontStyle: ButtonFontStyle.PoppinsSemiBold18,
                height: 48,
                width: 307,
                onTap: () {
                  Get.back(result: true);
                    // Get.to(const MyBetHistoryScreen());
                },
              )
            ],
          ),
        );
      },
    ).then((value) {
      if(value == true){
        Get.back(result: true);
      }
    });
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;

    int fiftyYearsAgo = currentYear - 60;

    return await showDatePicker(
        helpText: "",
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime.now(),
        firstDate: DateTime(fiftyYearsAgo),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light().copyWith(
                  primary: ColorConstant.blueGray10096, // Customize the heading color
                ),
              ),
              child: child!);
        });
  }


  DateTime _selectedDate = DateTime.now();
  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != _selectedDate)       _selectedDate = pickedDate;
    return _selectedDate;
  }


  TimeOfDay _selectedTime = TimeOfDay.now();
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
    await showTimePicker(context: context, initialTime: _selectedTime);
    if (pickedTime != null && pickedTime != _selectedTime) {
      _selectedTime = pickedTime;
    }
    return _selectedTime;
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.5),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: Get.height / 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(20.0),
            child: TermsConditions(
              onPressed: () {
                controller.termsConditionsAccepted.value = true;
                Get.back();
              },
            ),
          ),
        );
      },
    );
  }
}
