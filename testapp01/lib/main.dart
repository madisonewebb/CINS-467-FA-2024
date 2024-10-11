import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Cat Pictures',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: CatImageScreen(),
    );
  }
}

class CatImageScreen extends StatefulWidget {
  @override
  _CatImageScreenState createState() => _CatImageScreenState();
}

class _CatImageScreenState extends State<CatImageScreen> {
  String catImageUrl = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchNewCatImage(); // Fetch an initial cat image when the app starts
  }

  Future<void> fetchNewCatImage() async {
    setState(() {
      isLoading = true; // Show the loading indicator while fetching
    });

    final response =
        await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        catImageUrl = data[0]['url'];
        isLoading = false; // Hide the loading indicator
      });
    } else {
      throw Exception('Failed to load cat image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Cat Pictures 🐱'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? CircularProgressIndicator() // Show loading indicator while fetching
                  : catImageUrl.isNotEmpty
                      ? Image.network(catImageUrl,
                          height: 300,
                          fit: BoxFit.cover) // Display the cat image
                      : Text('No image loaded yet.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    fetchNewCatImage, // Fetch a new image on button press
                child: Text('Witness More Cuteness'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
