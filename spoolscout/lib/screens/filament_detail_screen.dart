import 'package:flutter/material.dart';

class FilamentDetailsScreen extends StatelessWidget {
  final String filamentName;
  final String brandName;
  final String imageUrl;
  final double price;
  final String purchaseLink;
  final int spoolWeight; // in grams or kilograms
  final int filamentAmount; // total filament length or weight
  final int minTemp;
  final int maxTemp;
  final double rating; // Average star rating
  final List<Map<String, dynamic>> reviews; // List of user reviews

  const FilamentDetailsScreen({
    Key? key,
    required this.filamentName,
    required this.brandName,
    required this.imageUrl,
    required this.price,
    required this.purchaseLink,
    required this.spoolWeight,
    required this.filamentAmount,
    required this.minTemp,
    required this.maxTemp,
    required this.rating,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filamentName),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Name, Brand, Image, Price, and Link
            _buildTopSection(),

            SizedBox(height: 24),

            // Filament Specifications
            _buildSpecifications(),

            SizedBox(height: 24),

            // Reviews Section
            _buildReviewsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and Brand
        Text(
          '$filamentName by $brandName',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),

        // Image
        Center(
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                )
              : Placeholder(
                  fallbackHeight: 200,
                  color: Colors.grey,
                ),
        ),
        SizedBox(height: 16),

        // Price and Purchase Link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to purchase link
                launch(purchaseLink);
              },
              child: Text('Buy Now'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),

        // Temperature Range
        _buildSpecRow('Temperature Range:', '$minTemp°C - $maxTemp°C'),

        // Spool Weight
        _buildSpecRow('Spool Weight:', '$spoolWeight g'),

        // Filament Amount
        _buildSpecRow('Filament Amount:', '$filamentAmount m'),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reviews Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text(
                  '$rating',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),

        // List of Reviews
        ...reviews.map((review) => _buildReviewCard(review)).toList(),

        // Add Review Button
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Navigate to review submission form
          },
          child: Text('Add a Review'),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reviewer Name and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < review['rating'] ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Review Text
            Text(
              review['reviewText'],
              style: TextStyle(fontSize: 14),
            ),

            // Optional Review Image
            if (review['imageUrl'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.network(
                  review['imageUrl'],
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
