import 'package:flexx_bet/ui/components/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../webview_page/webview_page.dart';

class SingleBanner extends StatelessWidget {
  const SingleBanner(
      {super.key,
      required this.imagePath,
      this.showOverlay = true,
      required this.subTitle,
      required this.title,
        required this.url
      });
  final String imagePath;
  final bool showOverlay;
  final String title;
  final String subTitle;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>WebViewPageForSlider(url)));
      },
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: Stack(
              children: <Widget>[
                CustomImageView(
                    imagePath: imagePath,
                    fit: BoxFit.cover,
                    height: Get.height / 3.5,
                    width: Get.width),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: showOverlay
                          ? const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 115, 64, 255),
                                Color.fromARGB(34, 115, 64, 255)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subTitle,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
