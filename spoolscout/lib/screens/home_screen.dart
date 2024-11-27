import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spoolscout/widgets/badge_icon.dart';
import 'profile_screen.dart';
import 'details_screen.dart'; // New screen for details

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  // Dummy data
  final List<String> categories = ["High Flow", "Flexible", "Durable"];
  final List<String> brands = [
    "Bambu",
    "Prusa",
    "Overture",
    "Hatchbox",
    "Sunlu",
    "Protopasta",
    "Elegoo",
    "Polymaker",
    "Amazon Basics",
    "Amolen",
    "Anycubic",
    "Creality",
    "Eryone",
    "eSun",
    "Extrudr"
  ];
  final List<String> types = [
    "PLA",
    "ABS",
    "PETG",
    "ASA",
    "Nylon",
    "TPU",
    "Carbon Fiber"
  ];
  final List<String> favorites = ["PLA Black", "ABS Red", "PETG Blue"];
  final List<String> myFilaments = ["PLA Green", "TPU Yellow", "Nylon White"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spool Scout"),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage('assets/placeholder.png') as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSection("Categories", categories, Colors.blue, context),
          SizedBox(height: 24),
          _buildSection("Popular Brands", brands, Colors.green, context),
          SizedBox(height: 24),
          _buildSection(
              "Popular Filament Types", types, Colors.orange, context),
          SizedBox(height: 24),
          _buildSection("My Favorites", favorites, Colors.purple, context),
          SizedBox(height: 24),
          _buildSection("My Filaments", myFilaments, Colors.teal, context),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, List<String> items, Color color, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        _buildHorizontalScroll(items, color, context),
      ],
    );
  }

  Widget _buildHorizontalScroll(
      List<String> items, Color color, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BadgeIcon(
              label: item,
              badgeColor: color,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(item: item),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
