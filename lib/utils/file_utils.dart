import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FileUtils {
  static Future<File?> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        // maxWidth: 200,
        // maxHeight: 200,
        // imageQuality: 80,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<File>?> getMultipleImagesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> pickedFile = await picker.pickMultiImage();
      var files = <File>[];
      for (var element in pickedFile) {
        files.add(File(element.path));
        continue;
      }
      return files;
    } catch (e) {
      return null;
    }
  }

  static Future<File?> getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        // maxWidth: 200,
        // maxHeight: 200,
        // imageQuality: 80,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static String getFileDisplayName(File file) {
    // Use the 'uri' property to get the file path
    String path = file.uri.path;

    // Split the path by the platform-specific file separator
    List<String> parts = path.split(Platform.pathSeparator);

    // Get the last part, which should be the file name
    return parts.last;
  }
}
