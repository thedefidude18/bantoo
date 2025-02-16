import 'package:get/get.dart';

class SelectionController<T> extends GetxController {
  late Rx<T> _selection;
  SelectionController(T defaultValue) {
    _selection = defaultValue.obs;
  }

  get selection => _selection.value;
  void setSelection(value) {
    _selection.value = value;
    update();
  }
}
