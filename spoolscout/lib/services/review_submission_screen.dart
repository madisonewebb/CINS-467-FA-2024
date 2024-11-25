import 'package:flutter/material.dart';
import 'dart:io';
import '../services/image_service.dart';

class ReviewSubmissionScreen extends StatefulWidget {
  @override
  _ReviewSubmissionScreenState createState() => _ReviewSubmissionScreenState();
}

class _ReviewSubmissionScreenState extends State<ReviewSubmissionScreen> {
  final ImageService imageService = ImageService();
  File? _imageFile;
  String? _uploadedImageUrl;

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final image = await imageService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  // Function to upload image and get URL
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final imageUrl = await imageService.uploadImage(
      _imageFile!,
      'reviews/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    setState(() {
      _uploadedImageUrl = imageUrl;
    });

    if (_uploadedImageUrl != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image uploaded successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Write your review here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 150,
                    width: 150,
                  )
                : Text('No image selected'),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo),
              label: Text('Pick Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
