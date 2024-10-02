// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/drive/v3.dart' as drive;
//
// class PickImageViewModel extends ChangeNotifier {
//
//
//   final ImagePicker _picker = ImagePicker();
//   static const _scopes = [drive.DriveApi.driveScope];
//
//   // Function to pick an image from the gallery
//   Future<void> _pickImageFromGallery() async {
//     try {
//       final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//
//       if (pickedImage != null) {
//         await _resizeAndReturnImage(File(pickedImage.path));
//       }
//     } catch (e) {
//       print('Error picking image from gallery: $e');
//     }
//   }
//
//   // Function to take a picture with the camera
//   Future<void> _takePicture() async {
//     try {
//       final XFile? capturedImage = await _picker.pickImage(source: ImageSource.camera);
//
//       if (capturedImage != null) {
//         await _resizeAndReturnImage(File(capturedImage.path));
//       }
//     } catch (e) {
//       print('Error capturing image: $e');
//     }
//   }
//
//   // Function to resize the image and call the callback with the resized image file
//
//
//
//   Future<void> _importFromGoogleDrive() async {
//     // You need to set up Google API Console and get your OAuth2 credentials
//     var clientId = ClientId("YOUR_CLIENT_ID", "YOUR_CLIENT_SECRET");
//     var client = await clientViaUserConsent(clientId, _scopes, (url) {
//       // This is where you'd prompt the user to go to the URL and authenticate
//       print("Please go to the following URL and grant access: $url");
//     });
//
//     var driveApi = drive.DriveApi(client);
//     // Here you can list files or open a file picker from Google Drive
//
//     // This example will list the first 10 files
//     try {
//       var fileList = await driveApi.files.list(pageSize: 10);
//       for (var file in fileList.files!) {
//         print('File: ${file.name} (${file.id})');
//       }
//       // For simplicity, we're not implementing a file picker here
//     } catch (e) {
//       print('Error fetching files from Google Drive: $e');
//     } finally {
//       client.close();
//     }
//   }
//
//   refreshUI() {
//     notifyListeners();
//   }
// }