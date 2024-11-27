import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  // Dummy data for favorites (replace with Firestore query)
  final List<String> favoriteFilaments = [
    'PLA+ Red',
    'ABS Blue',
    'PETG White',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteFilaments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteFilaments[index]),
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
