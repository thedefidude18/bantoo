import 'package:flutter/material.dart';
import 'package:flexx_bet/controllers/controllers.dart';

class LogoGraphicHeader extends StatelessWidget {
  LogoGraphicHeader({super.key});
  final ThemeController themeController = ThemeController.to;

  @override
  Widget build(BuildContext context) {
    String imageLogo = 'assets/images/default.png';
    if (themeController.isDarkModeOn == true) {
      imageLogo = 'assets/images/defaultDark.png';
    }
    return Hero(
      tag: 'App Logo',
      child: CircleAvatar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
            child: Image.asset(
              imageLogo,
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
            ),
          )),
    );
  }
}
