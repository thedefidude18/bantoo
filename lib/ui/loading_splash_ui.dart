import 'package:flutter/material.dart';

class LoadingSplashUI extends StatelessWidget {
  const LoadingSplashUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
