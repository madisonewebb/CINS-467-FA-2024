import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditSubmissionScreen extends StatefulWidget {
  final DocumentSnapshot submission;

  EditSubmissionScreen({required this.submission});

  @override
  _EditSubmissionScreenState createState() => _EditSubmissionScreenState();
}

class _EditSubmissionScreenState extends State<EditSubmissionScreen> {
  late TextEditingController typeController;
  late TextEditingController brandController;
  late TextEditingController attributesController;
  late TextEditingController temperatureController;

  @override
  void initState() {
    super.initState();
    typeController = TextEditingController(text: widget.submission['type']);
    brandController = TextEditingController(text: widget.submission['brand']);
    attributesController =
        TextEditingController(text: widget.submission['attributes'].join(', '));
    temperatureController = TextEditingController(
        text: widget.submission['temperature'].toString());
  }

  Future<void> _approveSubmission() async {
    final updatedData = {
      'type': typeController.text.trim(),
      'brand': brandController.text.trim(),
      'attributes': attributesController.text
          .trim()
          .split(',')
          .map((e) => e.trim())
          .toList(),
      'temperature': int.tryParse(temperatureController.text.trim()) ?? 0,
      'status': 'approved',
    };

    await FirebaseFirestore.instance
        .collection('filaments')
        .add(updatedData); // Move to main database.

    await widget.submission.reference.delete(); // Remove from submissions.

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Submission approved and added to the database.')),
    );
    Navigator.pop(context);
  }

  Future<void> _rejectSubmission() async {
    await widget.submission.reference.update({'status': 'rejected'});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Submission rejected.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Submission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: attributesController,
              decoration:
                  InputDecoration(labelText: 'Attributes (comma-separated)'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: temperatureController,
              decoration: InputDecoration(labelText: 'Temperature (°C)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _approveSubmission,
              child: Text('Approve'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _rejectSubmission,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Reject'),
            ),
          ],
        ),
      ),
    );
  }
}
