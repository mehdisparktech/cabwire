import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MediaHelper {
  static Future<String?> openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    return image?.path;
  }

  static Future<String?> openGalleryForProfile() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      return croppedFile?.path;
    }
    return null;
  }

  static Future<String?> pickVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    return video?.path;
  }

  static Future<String?> openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    return image?.path;
  }
}