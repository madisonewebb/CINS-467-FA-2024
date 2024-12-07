import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'filament_detail_screen.dart'; // Import the detail screen

class FilteredFilamentsScreen extends StatelessWidget {
  final String filter;

  const FilteredFilamentsScreen({Key? key, required this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered: $filter'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('approvedFilaments')
            .where('attributes', arrayContains: filter)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No filaments match this filter.'));
          }

          final filaments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: filaments.length,
            itemBuilder: (context, index) {
              final filament = filaments[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(
                  filament['imageUrl'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(filament['type'] ?? 'Unknown Type'),
                subtitle: Text(filament['brand'] ?? 'Unknown Brand'),
                onTap: () {
                  // Navigate to FilamentDetailScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FilamentDetailScreen(filament: filament),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
