import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/models/discussion_model.dart';
import 'package:wordpress_app/models/message.dart';
import 'package:wordpress_app/services/messages_service.dart';
import 'package:wordpress_app/tabs/conversations_tab.dart';

class FileService {
  File? imageFile;

  Future getImage(
      String type, DiscussionModel discussion, Message message) async {
    XFile? pickedFile;
    // final storage = FirebaseStorage.instance;
    if (type == "Camera") {
      ///Pick image from camera
      ImagePicker? imagePicker = ImagePicker();
      // pickedFile = (await imagePicker.getImage(source: ImageSource.camera));
      pickedFile = (await imagePicker.pickImage(source: ImageSource.camera));
      imageFile = File(pickedFile!.path);
      await updloadFileToStorage(
          imageFile!.path, pickedFile.name, discussion, message);
    } else if (type == "Gallery") {
      ///Pick image from gallery
      ImagePicker imagePicker = ImagePicker();
      pickedFile = (await imagePicker.pickImage(source: ImageSource.gallery));
      imageFile = File(pickedFile!.path);
      await updloadFileToStorage(
          imageFile!.path, pickedFile.name, discussion, message);
    } else if (type == "Document") {
      ///Pick document
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );

      imageFile = File(result!.files.single.path!);
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      imageFile = File(result!.files.single.path!);
    }
    // updloadFileToStorage(imageFile!.path, senderUid);
  }

  updloadFileToStorage(String filePath, fileName, DiscussionModel discussion,
      Message message) async {
    final file = File(filePath);

// Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the dartFirebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child(message.senderUid + "/" + message.receiverUid + "/" + fileName)
        .putFile(file, metadata);

// Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          await _getImageUrl(fileName, discussion, message);
          // Handle successful uploads on complete
          // ...
          break;
      }
    });
  }

  Future<String> _getImageUrl(
      String fileName, DiscussionModel discussion, Message message) async {
    String url = await FirebaseStorage.instance
        .ref(message.senderUid + "/" + message.receiverUid + "/" + fileName)
        .getDownloadURL();
    message.fileUrl = url;
    MessagesService().sendMessages(discussion, message);
    return url;
  }
}
