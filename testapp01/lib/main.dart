import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const GoalTrackerApp());
}

class GoalTrackerApp extends StatelessWidget {
  const GoalTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const GoalTrackerPage(),
    );
  }
}

class GoalTrackerPage extends StatefulWidget {
  const GoalTrackerPage({super.key});

  @override
  State<GoalTrackerPage> createState() => _GoalTrackerPageState();
}

class _GoalTrackerPageState extends State<GoalTrackerPage> {
  final _formKey = GlobalKey<FormState>();
  String _goal = '';
  int _progress = 0;
  String _priority = 'Medium';
  List<String> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  // Load goals from shared preferences
  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goals = prefs.getStringList('goals') ?? [];
    });
  }

  // Save goals to shared preferences
  Future<void> _saveGoal() async {
    final prefs = await SharedPreferences.getInstance();
    _goals.add('Goal: $_goal, Progress: $_progress%, Priority: $_priority');
    await prefs.setStringList('goals', _goals);
    _loadGoals();
  }

  // Form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveGoal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Goal Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Goal'),
                    onSaved: (value) => _goal = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a goal';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Progress (%)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _progress = int.parse(value!),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your progress';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) < 0 ||
                          int.parse(value) > 100) {
                        return 'Please enter a valid number (0-100)';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _priority,
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                    ],
                    onChanged: (value) => setState(() => _priority = value!),
                    decoration: const InputDecoration(labelText: 'Priority'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Add Goal'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Goals List:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_goals[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
