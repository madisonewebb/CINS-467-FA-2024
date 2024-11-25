import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spool Scout Filaments'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getFilaments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No filaments found.'));
          }

          final filaments = snapshot.data!;

          return ListView.builder(
            itemCount: filaments.length,
            itemBuilder: (context, index) {
              final filament = filaments[index];
              return ListTile(
                title: Text(filament['name']),
                subtitle: Text('Type: ${filament['type']}, Price: \$${filament['price']}'),
                trailing: Text('Temp: ${filament['printTempLow']}°C - ${filament['printTempHigh']}°C'),
              );
            },
          );
        },
      ),
    );
  }
}
