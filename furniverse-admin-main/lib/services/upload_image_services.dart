import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> uploadImageToFirebase(XFile? imageFile) async {
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child('product_images/${DateTime.now()}.jpg');
  UploadTask uploadTask = storageReference.putFile(File(imageFile!.path));
  TaskSnapshot snapshot = await uploadTask;
  if (snapshot.state == TaskState.success) {
    return await snapshot.ref.getDownloadURL();
  }

  return null;
}

Future<void> deleteImageFromFirebase(String imageUrl) async {
  try {
    Reference storageReference = FirebaseStorage.instance.refFromURL(imageUrl);
    await storageReference.delete();
  } catch (e) {
    print("Error deleting image: $e");
  }
}

Future<String?> uploadVariantImageToFirebase(XFile? imageFile) async {
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child('variant_images/${DateTime.now()}.jpg');
  UploadTask uploadTask = storageReference.putFile(File(imageFile!.path));
  TaskSnapshot snapshot = await uploadTask;
  if (snapshot.state == TaskState.success) {
    return await snapshot.ref.getDownloadURL();
  }

  return null;
}
