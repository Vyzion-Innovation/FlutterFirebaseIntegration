import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ImageHelper {
  
  static Future<File?> getImageFromGallery() async {
    final picker = ImagePicker();
    File? tempImage;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      tempImage = File(pickedFile.path);
      tempImage = await _cropImage(imageFile: tempImage);
      return tempImage;
    }
    return null;
  }

  static Future<File?> _cropImage({required File imageFile}) async {
    final Logger logger = Logger();
    try {
      CroppedFile? croppedImg = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressQuality: 30,
      );
      if (croppedImg == null) {
        return null;
      } else {
        return File(croppedImg.path);
      }
    } catch (e, stacktrace) {
    logger.e('An error occurred', e, stacktrace);
    return null;
    }
  }
 
}
