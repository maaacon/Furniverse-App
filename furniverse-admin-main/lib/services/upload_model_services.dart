import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadModelToFirebase(File? modelFile) async {
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child('product_3D_models/${DateTime.now()}.glb');
  UploadTask uploadTask = storageReference.putFile(File(modelFile!.path));
  TaskSnapshot snapshot = await uploadTask;
  if (snapshot.state == TaskState.success) {
    return await snapshot.ref.getDownloadURL();
  }

  return null;
}
