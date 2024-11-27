import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String item;

  const DetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item),
      ),
      body: Center(
        child: Text(
          'Details about $item',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
