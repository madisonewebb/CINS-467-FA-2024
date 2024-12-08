import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import
import 'filtered_filaments_screen.dart'; // Import filtered filaments screen
import 'filament_detail_screen.dart'; // Import filament detail screen
import 'profile_screen.dart'; // Import Profile Screen
import '../widgets/badge_icon.dart'; // Ensure correct import path
import 'dart:math';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Wallpaper background
          Image.asset(
            'assets/images/wallpaper.png',
            fit: BoxFit.cover,
          ),
          // Foreground content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar Section
                // App Bar Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png', // Path to the tiny logo
                            height: 48, // Adjust size for the tiny logo
                            width: 48,
                          ),
                          const SizedBox(
                              width: 8), // Space between logo and text
                          Text(
                            'Home',
                            style: TextStyle(
                              fontFamily: 'ChickenWonder',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(
                                  4, 107, 123, 1), // Ensures text is readable
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : AssetImage('assets/images/default_avatar.png')
                                  as ImageProvider,
                        ),
                      ),
                    ],
                  ),
                ),

                // Categories Section
                sectionHeader('Categories'),
                horizontalBadgeList(
                  labels: [
                    'Tough',
                    'Heat-resistant',
                    'Impact-resistant',
                    'Lightweight',
                    'Rigid',
                    'Transparent',
                  ],
                  context: context,
                ),
                sectionHeader('Popular Brands'),
                horizontalBadgeList(
                  labels: [
                    'Bambu',
                    'Prusa',
                    'eSun',
                    'Hatchbox',
                  ],
                  context: context,
                ),
                sectionHeader('Popular Filament Types'),
                horizontalBadgeList(
                  labels: [
                    'PLA',
                    'ABS',
                    'PETG',
                    'TPU',
                  ],
                  context: context,
                ),

                // Favorites Section
                sectionHeader('Favorites'),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('favorites')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final favorites = snapshot.data?.docs ?? [];
                    if (favorites.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'No favorited filaments... yet!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return horizontalImageBadgeList(
                      context: context,
                      filaments: favorites
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList(),
                    );
                  },
                ),
                // My Filaments Section
                sectionHeader('My Filaments'),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('library')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final library = snapshot.data?.docs ?? [];
                    if (library.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'No filaments in library.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return horizontalImageBadgeList(
                      context: context,
                      filaments: library
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'ChickenWonder',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(4, 107, 123, 1), // Ensures text is readable
        ),
      ),
    );
  }
  // Import for random color generation

  Widget horizontalBadgeList({
    required List<String> labels,
    required BuildContext context,
  }) {
    final List<Color> randomColors = List.generate(
      labels.length,
      (index) => _generateRandomColor(),
    );

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: labels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilteredFilamentsScreen(filter: label),
                ),
              );
            },
            child:
                BadgeWidget(label: label, backgroundColor: randomColors[index]),
          );
        }).toList(),
      ),
    );
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), // Red
      random.nextInt(256), // Green
      random.nextInt(256), // Blue
    );
  }

  Widget horizontalImageBadgeList({
    required BuildContext context,
    required List<Map<String, dynamic>> filaments,
  }) {
    return SizedBox(
      height: 120, // Adjust height to accommodate the brand name
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filaments.map((filament) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FilamentDetailScreen(filament: filament),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Use BadgeWidget's style for dashed and solid circles
                      CustomPaint(
                        size: const Size(100, 100),
                        painter: SolidCirclePainter(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
                      ),
                      CustomPaint(
                        size: const Size(100, 100),
                        painter: DashedCirclePainter(
                          color: Colors.black,
                          strokeWidth: 2,
                          dashLength: 5,
                          radiusFactor: 0.85,
                        ),
                      ),
                      // Clip image to fit inside the dashed circle
                      ClipOval(
                        child: Image.network(
                          filament['imageUrl'],
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4), // Space between image and brand name
                Text(
                  filament['brand'] ?? 'Unknown',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Color.fromRGBO(4, 107, 123, 1),
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
