import 'dart:io';

import 'package:flexx_bet/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  final AuthController _authController = AuthController.to;

  File? image;
  String? imagePath;
  final _picker = ImagePicker();

  Future<void> getImage(ImageSource imageSource) async {
    final pickedFile = await _picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath = pickedFile.path;
      await _authController.updateUserProfileImage(image!);

      update();
    } else {
      Get.log('No image selected.');
    }
  }
}
