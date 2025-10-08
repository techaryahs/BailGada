import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Splashscreen/SplashScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BailGada App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
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
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child("test/boolean");

  bool? storedValue;

  Future<void> _sendValue(bool value) async {
    await _dbRef.set(value);
  }

  Future<void> _fetchValue() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      setState(() {
        storedValue = snapshot.value as bool?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              storedValue == null
                  ? "No value fetched yet"
                  : "Fetched value: $storedValue",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendValue(true),
              child: const Text("Send TRUE"),
            ),
            ElevatedButton(
              onPressed: () => _sendValue(false),
              child: const Text("Send FALSE"),
            ),
            ElevatedButton(
              onPressed: _fetchValue,
              child: const Text("Fetch Value"),
            ),
          ],
        ),
      ),
    );
  }
}
