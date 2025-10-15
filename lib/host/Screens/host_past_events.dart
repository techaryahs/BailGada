import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../Screens/EventDetailsScreen.dart';

class HostPastEventsPage extends StatefulWidget {
  const HostPastEventsPage({super.key});

  @override
  State<HostPastEventsPage> createState() => _HostPastEventsPageState();
}

class _HostPastEventsPageState extends State<HostPastEventsPage> {
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
            child: Text("Error loading past events",
                style: TextStyle(color: Colors.redAccent)),
          );
        }

        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return const Center(
            child: Text(
              "No past events available.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        final data = Map<dynamic, dynamic>.from(
            snapshot.data!.snapshot.value as Map);
        final allEvents = data.entries.map((e) {
          return Map<String, dynamic>.from(e.value);
        }).toList();

        // ✅ Filter only past events
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final pastEvents = allEvents.where((event) {
          if (event['eventDate'] == null) return false;
          try {
            final date = DateTime.parse(event['eventDate']);
            final eventDay = DateTime(date.year, date.month, date.day);
            return eventDay.isBefore(today);
          } catch (_) {
            return false;
          }
        }).toList();

        if (pastEvents.isEmpty) {
          return const Center(
            child: Text(
              "No past events found.",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "⏳ Your Past Events",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.orange, blurRadius: 2)],
                ),
              ),
              const SizedBox(height: 20),
              ...pastEvents.map((event) => _buildEventCard(context, event)),
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
                        colors: [Colors.grey, Colors.blueGrey],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "ENDED",
                      style: TextStyle(
                        color: Colors.white,
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

            // ⚙️ Manage Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  _buildActionButton(
                    icon: Icons.bar_chart,
                    label: "View Results",
                    gradient: const LinearGradient(
                      colors: [Colors.deepOrange, Colors.orangeAccent],
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Results screen coming soon!"),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    icon: Icons.replay,
                    label: "Re-Host",
                    gradient: const LinearGradient(
                      colors: [Colors.tealAccent, Colors.teal],
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Re-Host feature coming soon!"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
