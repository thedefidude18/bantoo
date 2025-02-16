import "dart:io";

import "package:flexx_bet/ui/components/components.dart";
import "package:flexx_bet/ui/components/custom_appbar.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:webview_flutter/webview_flutter.dart";

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  String link = "https://tawk.to/chat/652ad137eb150b3fb9a15f82/1hcnk2i67";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
        showCreateEvent: false,
      ),
      body: SizedBox(
        width: Get.width,
        child: WebView(
          backgroundColor: Colors.white,
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (url) {
            showLoadingIndicator();
          },
          onPageFinished: (url) {
            hideLoadingIndicator();
          },
          initialUrl: link,
          gestureRecognizers: {}..add(
              Factory<DragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
              ),
            ),
        ),
      ),
    );
  }
}
