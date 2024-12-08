import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'filtered_filaments_screen.dart';
import 'filament_detail_screen.dart';
import 'profile_screen.dart';
import '../widgets/badge_icon.dart';
import 'dart:math';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/wallpaper.png',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 48,
                            width: 48,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontFamily: 'ChickenWonder',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(
                                4, 107, 123, 1),
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
          color: Color.fromRGBO(4, 107, 123, 1),
        ),
      ),
    );
  }

  Widget horizontalBadgeList({
    required List<String> labels,
    required BuildContext context,
  }) {
    final List<Color> randomColors = List.generate(
      labels.length,
      (index) => _generateRandomColor(),
    );

    return SizedBox(
      height: 150,
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
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: BadgeWidget(
                label: label,
                backgroundColor: randomColors[index],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _generateRandomColor() {
    // define a list of colors using hex codes
    final List<Color> predefinedColors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFFC107),
      const Color(0xFFFF5722),
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFFFFEB3B),
      const Color(0xFF795548),
      const Color(0xFF607D8B), 
    ];

    final Random random = Random();
    return predefinedColors[random.nextInt(predefinedColors.length)];
  }

  Widget horizontalImageBadgeList({
    required BuildContext context,
    required List<Map<String, dynamic>> filaments,
  }) {
    return SizedBox(
      height: 150,
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
                  width: 135,
                  height: 135,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(135, 135),
                        painter: SolidCirclePainter(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
                      ),
                      CustomPaint(
                        size: const Size(135, 135),
                        painter: DashedCirclePainter(
                          color: Colors.black,
                          strokeWidth: 2,
                          dashLength: 5,
                          radiusFactor: 0.85,
                        ),
                      ),
                      ClipOval(
                        child: Image.network(
                          filament['imageUrl'],
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),  // space between image and brand name
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
