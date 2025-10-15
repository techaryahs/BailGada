import 'package:flutter/material.dart';
import '../utils/translation_helper.dart';
import '../services/translation_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  String _getNameKey(String baseName, BuildContext context) {
    final translationService = TranslationService();
    if (translationService.currentLanguage == 'mr') {
      return '${baseName}_mr';
    }
    return baseName;
  }

  @override
  Widget build(BuildContext context) {
    final racers = [
      {"nameKey": 'rohit_pawar', "points": 250, "rank": 1},
      {"nameKey": 'suresh_patil', "points": 210, "rank": 2},
      {"nameKey": 'vikram_jadhav', "points": 180, "rank": 3},
      {"nameKey": 'nitin_gaikwad', "points": 160, "rank": 4},
      {"nameKey": 'rajesh_shinde', "points": 140, "rank": 5},
    ];

    return TranslationBuilder(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('leaderboard'.tr),
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
                _getNameKey(racer['nameKey'].toString(), context).tr,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                "${racer['points']} ${'points'.tr}",
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}
