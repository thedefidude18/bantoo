import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
      {super.key,
      required this.name,
      required this.imagePath,
      required this.gradientColors,
      this.active = false,
      this.singleLine = false});
  final String name;
  final List<Color> gradientColors;
  final bool singleLine;
  final bool active;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 90,
              height: singleLine ? 40 : 115,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    stops: const [0, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  color: active ? ColorConstant.black900 : Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8,
                        spreadRadius: 8,
                        color: Colors.grey[100]!,
                        offset: const Offset(1, 1))
                  ]),
              child: singleLine
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        active
                            ? CustomImageView(
                                imagePath: imagePath,
                                height: Get.height / 25,
                              )
                            : const SizedBox(),
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? ColorConstant.whiteA700
                                  : ColorConstant.black900),
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(90)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: active
                                        ? ColorConstant.whiteA700
                                        : ColorConstant.black900),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.categorySmallStar,
                                height: 9,
                              )
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomImageView(
                              imagePath: imagePath,
                              height: 70,
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
