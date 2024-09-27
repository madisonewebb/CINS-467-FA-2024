import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Cats',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const MyHomePage(title: 'Meet My Cats!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _currentCat; // No image initially

  void _showKibby() {
    setState(() {
      _currentCat = 'assets/images/kibby.jpg';
    });
  }

  void _showMeowMeow() {
    setState(() {
      _currentCat = 'assets/images/meowmeow.jpg';
    });
  }

  void _showPartyPants() {
    setState(() {
      _currentCat = 'assets/images/partypants.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _currentCat != null
              ? Image.asset(
                  _currentCat!, // Display the selected cat image
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                )
              : const SizedBox(
                  height: 300,
                  child: Center(child: Text('No image selected')),
                ),
          const SizedBox(height: 20),
          const Text(
            'Tap a button to see one of my cats:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: _showKibby,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 234, 131, 188),
                ),
                child: const Text('Kibby'),
              ),
              ElevatedButton(
                onPressed: _showMeowMeow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 104, 169, 84),
                ),
                child: const Text('Meow Meow'),
              ),
              ElevatedButton(
                onPressed: _showPartyPants,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 234, 213, 55),
                ),
                child: const Text('Party Pants'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
