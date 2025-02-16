import 'package:flutter/material.dart';
import 'package:get/get.dart';

//loading indicator code is a modified and simplified version of this code
//https://github.com/fayaz07/ots

final _tKey = GlobalKey(debugLabel: 'overlay_parent');

/// Updates with the latest [OverlayEntry] child
late OverlayEntry _loaderEntry;

/// is dark theme
bool isDarkTheme = false;

/// To keep track if the [Overlay] is shown
bool loaderShown = false;

class Loading extends StatelessWidget {
  final Widget? child;
  final bool darkTheme;

  const Loading({Key? key, this.child, this.darkTheme = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    isDarkTheme = darkTheme;
    return SizedBox(
      width: Get.width,
      height: Get.height,
      key: _tKey,
      child: child,
    );
  }
}

OverlayState? get _overlayState {
  final context = _tKey.currentContext;
  if (context == null) return null;

  NavigatorState? navigator;

  void visitor(Element element) {
    if (navigator != null) return;

    if (element.widget is Navigator) {
      navigator = (element as StatefulElement).state as NavigatorState;
    } else {
      element.visitChildElements(visitor);
    }
  }

  // ignore: unused_element
  context.visitChildElements(visitor);

  assert(navigator != null, '''unable to show overlay''');
  return navigator!.overlay;
}

/// To handle a loader for the application
Future<void> showLoadingIndicator(
    {bool isModal = true, Color? modalColor}) async {
  try {
    debugPrint('Showing loading overlay');
    const child = IgnorePointer(
      child: SizedBox(
        child: Center(
          child: SizedBox(
              width: 40, height: 40, child: CircularProgressIndicator()),
        ),
      ),
    );
    await _showOverlay(
      child: isModal
          ? Stack(
              children: <Widget>[
                ModalBarrier(
                  color: modalColor,
                ),
                child
              ],
            )
          : child,
    );
  } catch (err) {
    debugPrint('Exception showing loading overlay\n${err.toString()}');
    rethrow;
  }
}

Future<void> hideLoadingIndicator() async {
  try {
    debugPrint('Hiding loading overlay');
    await _hideOverlay();
  } catch (err) {
    debugPrint('Exception hiding loading overlay');
    rethrow;
  }
}

///----------------------------------------------------------------------------
/// These methods deal with showing and hiding the overlay
Future<void> _showOverlay({required Widget child}) async {
  try {
    final overlay = _overlayState;

    if (loaderShown) {
      debugPrint('An overlay is already showing');
      // ignore: void_checks
      return Future.value(false);
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => child,
    );

    overlay?.insert(overlayEntry);
    _loaderEntry = overlayEntry;
    loaderShown = true;
  } catch (err) {
    debugPrint('Exception inserting loading overlay\n${err.toString()}');
    rethrow;
  }
}

Future<void> _hideOverlay() async {
  try {
    _loaderEntry.remove();
    loaderShown = false;
  } catch (err) {
    debugPrint('Exception removing loading overlay\n${err.toString()}');
    rethrow;
  }
}
