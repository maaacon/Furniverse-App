import 'package:firebase_storage/firebase_storage.dart';

void deleteFileByUrl(String fileUrl) async {
  try {
    // Get reference to the file
    final reference = FirebaseStorage.instance.refFromURL(fileUrl);

    // Delete the file
    await reference.delete();

    print('File deleted successfully');
  } catch (e) {
    print('Error deleting file: $e');
  }
}
