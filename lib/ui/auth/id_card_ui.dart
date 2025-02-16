import 'dart:io';
import 'dart:math';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/helpers/size.dart';
import 'package:flexx_bet/ui/auth/id_card_preview_ui.dart';
import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as image;
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoIDCardScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const PhotoIDCardScreen({super.key, required this.cameras});

  @override
  State<PhotoIDCardScreen> createState() => _PhotoIDCardScreenState();
}

class _PhotoIDCardScreenState extends State<PhotoIDCardScreen> {
  bool _isRearCameraSelected = true;
  late CameraController _cameraController;

  Future initCamera(CameraDescription cameraDescription) async {
// create a CameraController
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
// Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) async {
        await _cameraController.lockCaptureOrientation();
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize the rear camera
    initCamera(widget.cameras![0]);
  }

  Future cropImage(XFile picture) async {
    var decodedImage =
        await decodeImageFromList(File(picture.path).readAsBytesSync());

    // int offsetX = (decodedImage.width * 0.5).toInt();
    // int offsetY = (decodedImage.height * 0.5).toInt();

    final imageBytes = image.decodeImage(File(picture.path).readAsBytesSync())!;

    var cropSize = min(decodedImage.width, decodedImage.height);
    int offsetX =
        (decodedImage.width - min(decodedImage.width, decodedImage.height)) ~/
            2;
    int offsetY =
        (decodedImage.height - min(decodedImage.width, decodedImage.height)) ~/
            2;

    image.Image cropOne = image.copyCrop(
      imageBytes,
      radius: 15,
      x: offsetX,
      y: offsetY,
      height: cropSize,
      width: cropSize,
    );

    if (kDebugMode) {
      print(
          "height:${(decodedImage.height * 0.3).toInt()} width:${(decodedImage.width * 0.85).toInt()}");
    }

    File(picture.path).writeAsBytes(image.encodeJpg(cropOne));
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      await cropImage(picture);
      Get.log("TO PreviewIDCardScreen");
      Get.to(() => PreviewIDCardScreen(picture: picture));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceRatio = Get.width / Get.height;
    return Scaffold(
        backgroundColor: ColorConstant.black900,
        body: SafeArea(
          child: Stack(children: [
            (_cameraController.value.isInitialized)
                ? Center(
                    child: AspectRatio(
                      aspectRatio: deviceRatio,
                      child: CameraPreview(_cameraController),
                    ),
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator())),
            const OverlayWithRectangleClipping(),
            AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 60, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Photo Id card",
                    style: TextStyle(
                        color: ColorConstant.whiteA700, fontSize: HEADING_SIZE),
                  ),
                  Text(
                    "Please point the camera at the ID card",
                    style: TextStyle(color: ColorConstant.whiteA700),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                      color: Colors.transparent),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Expanded(
                            child: IconButton(
                          onPressed: takePicture,
                          iconSize: 100,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: ColorConstant.gray300,
                                borderRadius: BorderRadius.circular(500),
                              ),
                              child: Icon(Icons.circle,
                                  color: ColorConstant.primaryColor)),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() =>
                                _isRearCameraSelected = !_isRearCameraSelected);
                            initCamera(
                                widget.cameras![_isRearCameraSelected ? 0 : 1]);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                                color: ColorConstant.whiteA700,
                                borderRadius: BorderRadius.circular(100)),
                            padding: const EdgeInsets.all(10),
                            child: CustomImageView(
                                imagePath: ImageConstant.changeCameraIcon,
                                color: ColorConstant.black900),
                          ),
                        )),
                      ]),
                )),
          ]),
        ));
  }
}

class OverlayWithRectangleClipping extends StatelessWidget {
  const OverlayWithRectangleClipping({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: _getCustomPaintOverlay(context));
  }

  //CustomPainter that helps us in doing this
  CustomPaint _getCustomPaintOverlay(BuildContext context) {
    return CustomPaint(
        size: MediaQuery.of(context).size, painter: RectanglePainter());
  }
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    canvas.drawPath(
        Path.combine(
          PathOperation.difference, //simple difference of following operations
          //bellow draws a rectangle of full screen (parent) size
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          //bellow clips out the circular rectangle with center as offset and dimensions you need to set
          Path()
            ..addRRect(RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: Offset(size.width * 0.5, size.height * 0.5),
                    width: size.width * 0.85,
                    height: size.height * 0.3),
                const Radius.circular(15)))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
