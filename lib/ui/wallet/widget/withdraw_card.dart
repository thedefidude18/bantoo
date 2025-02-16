import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/bank_controller.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawCard extends StatelessWidget {
  final Map<String, dynamic> currentBank;

  final String image;
  const WithdrawCard({
    super.key,
    required this.currentBank,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BanksController>(builder: (controller) {
      return Container(
        margin: const EdgeInsets.fromLTRB(26, 10, 26, 26),
        width: Get.width,
        height: 60,
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
            color: ColorConstant.whiteA700,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: GestureDetector(
          onTap: () {
            controller.currentSelectedBank.value = currentBank;
            controller.update();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: CustomImageView(
                      imagePath: image,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * .45,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            currentBank["name"],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              controller.currentSelectedBank.value!["code"] ==
                      currentBank["code"]
                  ? Container(
                      decoration: BoxDecoration(
                          color: ColorConstant.primaryColor,
                          borderRadius: BorderRadius.circular(60)),
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.check,
                        color: ColorConstant.whiteA700,
                        size: 20,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: 1, color: Colors.grey[300]!)),
                      width: 30,
                      height: 30,
                    )
            ],
          ),
        ),
      );
    });
  }
}
