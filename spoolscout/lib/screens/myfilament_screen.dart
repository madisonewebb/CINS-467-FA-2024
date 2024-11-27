import 'package:flutter/material.dart';

class MyFilamentsScreen extends StatelessWidget {
  // Dummy data for owned filaments (replace with Firestore query)
  final List<String> ownedFilaments = [
    'PLA Black',
    'ABS Green',
    'Nylon Yellow',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Filaments'),
      ),
      body: ListView.builder(
        itemCount: ownedFilaments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ownedFilaments[index]),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to filament detail screen (optional)
            },
          );
        },
      ),
    );
  }
}
