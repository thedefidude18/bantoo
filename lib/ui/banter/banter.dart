import 'dart:io';
import 'package:flexx_bet/controllers/landing_page_controller.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BanterScreen extends StatefulWidget {
  const BanterScreen({super.key});

  @override
  State<BanterScreen> createState() => _BanterScreenState();
}

class _BanterScreenState extends State<BanterScreen> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        LandingPageController.to.changeTabIndex(0);
        return true;
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          showBackButton: true,
        ),
        body: Stack(
          children: [
            WebView(
              backgroundColor: Colors.white,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (url) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                });
              },
              initialUrl: 'https://bet.goflexx.app/entry/',
              gestureRecognizers: {}..add(
                  Factory<DragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
