import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:provider/provider.dart';
import 'package:todolist/pick_image/pick_image_viewmodel.dart';

class PickImage extends StatefulWidget {
  final Function(File) onImagePicked;

  const PickImage({Key? key, required this.onImagePicked}) : super(key: key);

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  final ImagePicker _picker = ImagePicker();
  static const _scopes = [drive.DriveApi.driveScope];

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        await _resizeAndReturnImage(File(pickedImage.path));
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  // Function to take a picture with the camera
  Future<void> _takePicture() async {
    try {
      final XFile? capturedImage = await _picker.pickImage(source: ImageSource.camera);

      if (capturedImage != null) {
        await _resizeAndReturnImage(File(capturedImage.path));
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  // Function to resize the image and call the callback with the resized image file
  Future<void> _resizeAndReturnImage(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);
    if (image != null) {
      img.Image resizedImage = img.copyResize(image, width: 800);
      List<int> resizedImageBytes = img.encodeJpg(resizedImage, quality: 80);
      File resizedImageFile = await File(
          '${imageFile.parent.path}/resized_${imageFile.path.split('/').last}')
          .writeAsBytes(resizedImageBytes);

      // Call the callback with the resized image file
      widget.onImagePicked(resizedImageFile);
    } else {
      print('No image selected.');
    }
  }

  // Function to import an image from Google Drive
  Future<void> _importFromGoogleDrive() async {
    // You need to set up Google API Console and get your OAuth2 credentials
    var clientId = ClientId("YOUR_CLIENT_ID", "YOUR_CLIENT_SECRET");
    var client = await clientViaUserConsent(clientId, _scopes, (url) {
      // This is where you'd prompt the user to go to the URL and authenticate
      print("Please go to the following URL and grant access: $url");
    });

    var driveApi = drive.DriveApi(client);
    // Here you can list files or open a file picker from Google Drive

    // This example will list the first 10 files
    try {
      var fileList = await driveApi.files.list(pageSize: 10);
      for (var file in fileList.files!) {
        print('File: ${file.name} (${file.id})');
      }
      // For simplicity, we're not implementing a file picker here
    } catch (e) {
      print('Error fetching files from Google Drive: $e');
    } finally {
      client.close();
    }
  }

  //late PickImageViewModel _viewModel;


  @override
  Widget build(BuildContext context) {
    //_viewModel = context.watch<PickImageViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            children: [
              Center(
                child: Text(
                  'Change Account Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Jost',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Color(0xff979797)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _takePicture,
                child: const Text(
                  "Take picture",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Jost',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: const Text(
                  "Import from gallery",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Jost',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _importFromGoogleDrive,
                child: const Text(
                  "Import from Google Drive",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Jost',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
