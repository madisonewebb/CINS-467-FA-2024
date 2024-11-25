import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: user@example.com'),
            SizedBox(height: 16),
            Text(
              'My Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2, // placeholder for reviews
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Review ${index + 1}'),
                    subtitle: Text('Great filament!'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
