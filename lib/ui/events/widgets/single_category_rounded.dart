import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({
    super.key,
    required this.name,
    required this.imagePath,
    this.onTap,
    this.active = false,
  });
  final String name;
  final bool active;
  final void Function()? onTap;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
        child: Column(
          children: [
            Container(
                width: Get.width / 4.5,
                height: Get.height / 10.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: active
                      ? Colors.white
                      : Colors.grey[100]!.withOpacity(0.4),
                ),
                child: Center(
                  child: CustomImageView(
                    imagePath: imagePath,
                    height: 50,
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.black900),
            )
          ],
        ),
      ),
    );
  }
}
