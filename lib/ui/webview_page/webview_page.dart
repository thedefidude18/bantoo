

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/landing_page_controller.dart';
import '../components/custom_appbar.dart';


class WebViewPageForSlider extends StatefulWidget {
  String url;
  WebViewPageForSlider(this.url, {super.key});

  @override
  State<WebViewPageForSlider> createState() => _WebViewPageForSliderState();
}

class _WebViewPageForSliderState extends State<WebViewPageForSlider> {

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          toolbarHeight: 0,
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
              initialUrl: widget.url,
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
