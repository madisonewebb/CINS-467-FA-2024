import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() => runApp(CameraApp());

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  List<File> _images = [];

  // Function to request camera permission
  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      _takePhoto();  // If permission granted, launch the camera
    } else if (status.isDenied) {
      print('Camera permission denied');
    } else if (status.isPermanentlyDenied) {
      // If the user permanently denies permission, direct them to app settings
      openAppSettings();
    }
  }

  // Function to take a photo
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue[900],
        appBar: AppBar(
          title: Text(
            'Camera App',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[900],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue[900],
                child: Center(
                  child: _images.isEmpty
                      ? Text('No image taken.', style: TextStyle(color: Colors.white))  // White text to contrast dark background
                      : Image.file(_images.last),
                ),
              ),
            ),
            Container(
              height: 100,
              color: Colors.blue[900],  // Set dark blue background for the thumbnail list area
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(_images[index], width: 80, height: 80),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _requestCameraPermission,  // Request camera permission before taking a photo
                child: Text('Take Photo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
