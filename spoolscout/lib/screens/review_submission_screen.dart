import 'package:flutter/material.dart';

class ReviewSubmissionScreen extends StatelessWidget {
  final TextEditingController reviewController = TextEditingController();

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
              controller: reviewController,
              decoration: InputDecoration(
                hintText: 'Write your review here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Image upload functionality will be added here
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Upload Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Submit review functionality will be added here
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
