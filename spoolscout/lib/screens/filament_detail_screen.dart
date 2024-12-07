import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FilamentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> filament;

  const FilamentDetailScreen({Key? key, required this.filament})
      : super(key: key);

  @override
  _FilamentDetailScreenState createState() => _FilamentDetailScreenState();
}

class _FilamentDetailScreenState extends State<FilamentDetailScreen> {
  bool isFavorite = false;
  bool inLibrary = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    if (user == null || widget.filament['id'] == null) return;

    try {
      final favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favorites')
          .doc(widget.filament['id']);

      final libraryRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('library')
          .doc(widget.filament['id']);

      final isFavoriteDoc = await favoritesRef.get();
      final inLibraryDoc = await libraryRef.get();

      setState(() {
        isFavorite = isFavoriteDoc.exists;
        inLibrary = inLibraryDoc.exists;
      });
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (user == null || widget.filament['id'] == null) {
      debugPrint('User or filament ID is null');
      return;
    }

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.filament['id']);

    try {
      if (isFavorite) {
        await favoritesRef.delete();
        debugPrint('Removed from favorites: ${widget.filament['id']}');
      } else {
        await favoritesRef.set(widget.filament);
        debugPrint('Added to favorites: ${widget.filament['id']}');
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> _toggleLibrary() async {
    if (user == null || widget.filament['id'] == null) {
      debugPrint('User or filament ID is null');
      return;
    }

    final libraryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('library')
        .doc(widget.filament['id']);

    try {
      if (inLibrary) {
        await libraryRef.delete();
        debugPrint('Removed from library: ${widget.filament['id']}');
      } else {
        await libraryRef.set(widget.filament);
        debugPrint('Added to library: ${widget.filament['id']}');
      }

      setState(() {
        inLibrary = !inLibrary;
      });
    } catch (e) {
      debugPrint('Error toggling library: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filament['type'] ?? 'Filament Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.filament['imageUrl'] ?? '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  size: 200,
                  color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              widget.filament['type'] ?? 'Unknown Type',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Brand: ${widget.filament['brand'] ?? 'Unknown Brand'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(
                    isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _toggleLibrary,
                  icon: Icon(
                    inLibrary ? Icons.library_add_check : Icons.library_add,
                  ),
                  label: Text(
                    inLibrary ? 'Remove from Library' : 'Add to Library',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.filament['description'] ?? 'No description available.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
