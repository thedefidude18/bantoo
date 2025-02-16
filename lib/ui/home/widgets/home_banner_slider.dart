import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key, required this.banners});
  final List<Widget> banners;

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  final CarouselSliderController _controller =
      CarouselSliderController(); // Updated to CarouselSliderController
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 160,
        width: Get.width,
        child: CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              aspectRatio: 2.4,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: widget.banners,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.banners.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 10.0,
              height: 10.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : ColorConstant.primaryColor)
                      .withOpacity(_current == entry.key ? 0.9 : 0.2)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
