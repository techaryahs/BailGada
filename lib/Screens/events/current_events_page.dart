import 'package:flutter/material.dart';

import '../EventDetailsScreen.dart';

class CurrentEventsPage extends StatelessWidget {
  const CurrentEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example events
    final List<Map<String, String>> currentEvents = [
      {
        "image": "assets/images/bailgada_poster.png",
        "title": "Maharashtra Championship 2025",
        "hostName": "Shivaji Patil",
        "hostImage": "assets/images/default_profile.jpg",
        "location": "Kolhapur, Maharashtra",
        "description":
        "Experience the thrill of ongoing Bullock Cart Races happening across Maharashtra! Witness the strength, speed, and tradition come alive on the tracks.",
      },
      {
        "image": "assets/images/bailgada_poster.png",
        "title": "BullPower Open Race",
        "hostName": "Rajesh Jadhav",
        "hostImage": "assets/images/default_profile.jpg",
        "location": "Sangli, Maharashtra",
        "description":
        "Get ready for the BullPower Open Race — where farmers and racers unite to showcase endurance and excellence in this year’s fastest track battle!",
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🔥 Current Events",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(color: Colors.orangeAccent, blurRadius: 1),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 🔥 Event Cards
          ...currentEvents.map((event) => _buildEventCard(context, event)),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, String> event) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.orange.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 Event Poster
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.asset(
                    event["image"]!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 16,
                    right: 16,
                    child: Text(
                      event["title"]!,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 👤 Host and Location Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(event["hostImage"]!),
                    backgroundColor: Colors.grey.shade800,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event["hostName"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: Colors.orangeAccent),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                event["location"]!,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.redAccent, Colors.red],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "LIVE",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // 📖 Short Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                event["description"]!,
                style: const TextStyle(color: Colors.white70, height: 1.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
