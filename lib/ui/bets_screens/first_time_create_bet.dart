import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/images.dart';
import 'create_bet_screen.dart';

class FirstTimeUserCreateGroup extends StatefulWidget {
  const FirstTimeUserCreateGroup({super.key});

  @override
  State<FirstTimeUserCreateGroup> createState() => _FirstTimeUserCreateGroupState();
}

class _FirstTimeUserCreateGroupState extends State<FirstTimeUserCreateGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(ImageConstant.createEventBack,fit: BoxFit.fill,)),
            Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40,left: 20,right: 20),
              child: CustomButton(
                text: "Create your event!",
               fontStyle:  ButtonFontStyle.PoppinsMedium16,
                height: 60,
                onTap: (){
                  Get.to(() => CreateBetScreen())?.then((value) {});
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}
