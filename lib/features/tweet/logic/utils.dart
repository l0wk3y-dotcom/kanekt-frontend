import 'package:image_picker/image_picker.dart';

Future<List<XFile>> enablePicker() async {
  final imagePicker = ImagePicker();
  final List<XFile>? images = await imagePicker.pickMultiImage();

  // Safely handle null or empty images
  if (images != null && images.isNotEmpty) {
    return images;
  } else {
    return []; // Return an empty list if no images are selected
  }
}
