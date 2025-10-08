import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final racers = [
      {"name": "Rohit Pawar", "points": 250, "rank": 1},
      {"name": "Suresh Patil", "points": 210, "rank": 2},
      {"name": "Vikram Jadhav", "points": 180, "rank": 3},
      {"name": "Nitin Gaikwad", "points": 160, "rank": 4},
      {"name": "Rajesh Shinde", "points": 140, "rank": 5},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Leaderboard"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: racers.length,
        itemBuilder: (context, index) {
          final racer = racers[index];
          return Card(
            color: Colors.black.withOpacity(0.8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.orange.withOpacity(0.5)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  "#${racer['rank']}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                "#${racer['name']}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                "${racer['points']} pts",
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
