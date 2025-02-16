import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:flexx_bet/controllers/image_picker_contoller.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/auth/create_pin_ui.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChooseProfilePictureScreen extends StatelessWidget {
  ChooseProfilePictureScreen({super.key});
  final ImageController imageController = Get.put(ImageController());
  final AuthController _authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.whiteA700,
        ),
        backgroundColor: ColorConstant.whiteA700,
        body: SizedBox(
          height: Get.height,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                getHorizontalSize(15), 10, getHorizontalSize(15), 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Profile Picture",
                          style: TextStyle(
                              fontSize: HEADING_SIZE,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text("Don’t worry, you can always change it later"),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GetBuilder<ImageController>(
                      init: ImageController(),
                      builder: (imageController) => SizedBox(
                        height: 200,
                        width: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                  _authController.userFirestore!.photoUrl,
                                )),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () => {_onPictureSelection()},
                                child: Container(
                                  width: Get.width / 6,
                                  height: Get.height / 13,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.gray200,
                                    border: Border.all(
                                        color: ColorConstant.whiteA700,
                                        width: 8),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  child: CustomImageView(
                                    svgPath: ImageConstant.editIcon,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  height: getVerticalSize(60),
                  fontStyle: ButtonFontStyle.PoppinsMedium16,
                  onTap: () async {
                    Get.offAll(() => const CreatePinScreen());
                  },
                  text: "Submit".toUpperCase(),
                ),
              ],
            ),
          ),
        ));
  }

  _onPictureSelection() async {
    Get.bottomSheet(Container(
      height: Get.height / 3,
      width: Get.width,
      padding: const EdgeInsets.all(8),
      color: ColorConstant.whiteA700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "Options For Image ",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: Get.width / 15, right: Get.width / 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                      side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(
                                width: 2,
                                color: ColorConstant.gray100,
                              ))),
                  onPressed: () {
                    Get.log("getImage");
                    Get.back();
                    imageController.getImage(ImageSource.camera);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 35,
                        color: ColorConstant.primaryColor,
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.black900,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(
                                width: 2,
                                color: ColorConstant.gray100,
                              ))),
                  onPressed: () {
                    Get.log("getImage");
                    Get.back();
                    imageController.getImage(ImageSource.gallery);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.image,
                        size: 35,
                        color: ColorConstant.primaryColor,
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.black900,
                            fontSize: 20),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
