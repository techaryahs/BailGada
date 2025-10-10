import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../Screens/EventDetailsScreen.dart';

class HostCurrentEventsPage extends StatefulWidget {
  const HostCurrentEventsPage({super.key});

  @override
  State<HostCurrentEventsPage> createState() => _HostCurrentEventsPageState();
}

class _HostCurrentEventsPageState extends State<HostCurrentEventsPage> {
  final DatabaseReference _eventsRef =
  FirebaseDatabase.instance.ref().child('events');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _eventsRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Error loading events",
                style: TextStyle(color: Colors.redAccent)),
          );
        }

        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return const Center(
            child: Text(
              "No current events yet!",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        final data = Map<dynamic, dynamic>.from(
            (snapshot.data! as DatabaseEvent).snapshot.value as Map);
        final allEvents = data.entries.map((e) {
          return Map<String, dynamic>.from(e.value);
        }).toList();

        // ✅ Filter: show only upcoming or ongoing events
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final currentEvents = allEvents.where((event) {
          if (event['eventDate'] == null) return false;
          try {
            final date = DateTime.parse(event['eventDate']);
            final eventDay = DateTime(date.year, date.month, date.day);
            return !date.isBefore(now) || eventDay.isAtSameMomentAs(today);
          } catch (_) {
            return false;
          }
        }).toList();

        if (currentEvents.isEmpty) {
          return const Center(
            child: Text(
              "No ongoing or upcoming events found.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🔥 Your Current Events",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.orange, blurRadius: 2)],
                ),
              ),
              const SizedBox(height: 20),

              // 🧾 Dynamic Event Cards
              ...currentEvents.map((event) => _buildEventCard(context, event)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
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
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 Event Poster
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  event["eventBannerPath"] != null
                      ? Image.file(
                    File(event["eventBannerPath"]),
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    "assets/images/bailgada_poster.png",
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
                    bottom: 12,
                    left: 16,
                    child: Text(
                      event["eventName"] ?? "Untitled Event",
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 👤 Host & Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                    AssetImage("assets/images/default_profile.jpg"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "You (Host)",
                          style: TextStyle(
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
                                event["eventLocation"] ?? "Unknown Location",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
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
                        colors: [Colors.orangeAccent, Colors.deepOrange],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 📖 Description
            if (event["eventIntro"] != null)
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  event["eventIntro"],
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
