import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/selection_controller.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopupCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String image;
  final String value;

  const TopupCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.image,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectionController>(
      builder: (SelectionController controller) {
        return Container(
          margin: const EdgeInsets.fromLTRB(26, 0, 26, 26),
          width: Get.width,
          padding: const EdgeInsets.fromLTRB(28, 20, 20, 20),
          decoration: BoxDecoration(
              color: ColorConstant.whiteA700,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: InkWell(
            onTap: () => controller.setSelection(value),
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
                    SizedBox(
                      width: getHorizontalSize(20),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 1, color: Colors.grey[300]!)),
                  width: 30,
                  height: 30,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
