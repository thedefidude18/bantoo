import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/controllers/selection_controller.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/auth/residency_proof_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationRadioButton extends StatelessWidget {
  final String name;
  final VerficationMethod value;

  const VerificationRadioButton({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectionController>(
      builder: (SelectionController controller) {
        return InkWell(
          onTap: () => controller.setSelection(value),
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 28, 20, 28),
            decoration: BoxDecoration(
                color: ColorConstant.blueGray100,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: getVerticalSize(30),
                        width: getHorizontalSize(30),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          border: Border.all(
                              color: ColorConstant.blue100, width: 3),
                          color: ColorConstant.radioColor,
                        ),
                        child: controller.selection == value
                            ? Container(
                                decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                border: Border.all(
                                    color: ColorConstant.blueA400, width: 8),
                                color: ColorConstant.radioColor,
                              ))
                            : const SizedBox(),
                      ),
                      SizedBox(
                        width: getHorizontalSize(20),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ]),
          ),
        );
      },
    );
  }
}
