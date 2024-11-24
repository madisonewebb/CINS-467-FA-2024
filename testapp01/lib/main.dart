import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'storage.dart'; // Ensure storage.dart exists and is correctly implemented

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Form App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Form Example'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: MyForm()), // Form for user input
          Expanded(child: UserData()), // View of data from Firebase
        ],
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int age = 0;

  final FirebaseService _firebaseService = FirebaseService(); // Made final for better practices

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  return value!.isEmpty ? 'Please enter your name' : null;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Age'),
                value: age == 0 ? null : age,
                items: List.generate(100, (index) => index + 1).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    age = value!;
                  });
                },
                validator: (value) {
                  return value == null ? 'Please select your age' : null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _firebaseService.saveUserData(name, age); // Save to Firebase
                    setState(() {
                      name = '';
                      age = 0; // Reset explicitly
                    });
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class UserData extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService(); // Marked as final

  UserData({Key? key})
      : super(key: key); // Added a key parameter to the constructor

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseService.getUsersStream(), // Fetch real-time data
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return ListTile(
              title: Text(doc['name']),
              subtitle: Text('Age: ${doc['age']}'),
            );
          }).toList(),
        );
      },
    );
  }
}
