import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FilamentDetailsScreen extends StatelessWidget {
  final String name;
  final String brand;
  final String imageUrl;
  final String price;
  final String buyLink;

  const FilamentDetailsScreen({
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.buyLink,
    Key? key,
  }) : super(key: key);

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl),
            SizedBox(height: 16),
            Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Brand: $brand', style: TextStyle(fontSize: 18)),
            Text('Price: $price', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchURL(buyLink),
              child: Text('Buy Now'),
            ),
          ],
        ),
      ),
    );
  }
}
