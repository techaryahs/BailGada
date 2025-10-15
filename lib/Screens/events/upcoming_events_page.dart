import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../utils/translation_helper.dart';

class UpcomingEventsPage extends StatefulWidget {
  const UpcomingEventsPage({super.key});

  @override
  State<UpcomingEventsPage> createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<UpcomingEventsPage> {
  final DatabaseReference _eventsRef =
  FirebaseDatabase.instance.ref().child('events');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _eventsRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.greenAccent),
          );
        }

        if (snapshot.hasError) {
          return TranslationBuilder(
            builder: (context) => Center(
              child: Text(
                'error_loading_upcoming_events'.tr,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return TranslationBuilder(
            builder: (context) => Center(
              child: Text(
                'no_upcoming_events_available'.tr,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          );
        }

        // Convert Firebase snapshot data
        final data = Map<dynamic, dynamic>.from(
            snapshot.data!.snapshot.value as Map);
        final allEvents = data.entries.map((e) {
          return Map<String, dynamic>.from(e.value);
        }).toList();

        // ✅ Filter: only events scheduled in the future
        final now = DateTime.now();
        final upcomingEvents = allEvents.where((event) {
          if (event['eventDate'] == null) return false;
          try {
            final date = DateTime.parse(event['eventDate']);
            return date.isAfter(now);
          } catch (_) {
            return false;
          }
        }).toList();

        if (upcomingEvents.isEmpty) {
          return TranslationBuilder(
            builder: (context) => Center(
              child: Text(
                "📅 ${'no_upcoming_events'.tr}",
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        return TranslationBuilder(
          builder: (context) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📅 ${'upcoming_events'.tr}",
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.green, blurRadius: 2)],
                  ),
                ),
                const SizedBox(height: 16),

                // 🧾 Upcoming Event Cards
                ...upcomingEvents.map((event) => _buildUpcomingEventCard(event)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingEventCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Event Banner
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
                  child: TranslationBuilder(
                    builder: (context) => Text(
                      event["eventName"] ?? 'unnamed_event'.tr,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📅 Event Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event["eventIntro"] != null)
                  Text(
                    event["eventIntro"],
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.greenAccent),
                    const SizedBox(width: 6),
                    TranslationBuilder(
                      builder: (context) => Text(
                        event["eventDate"]?.substring(0, 10) ??
                            'unknown_date'.tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.greenAccent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TranslationBuilder(
                        builder: (context) => Text(
                          event["eventLocation"] ?? 'unknown_location'.tr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.greenAccent, Colors.green],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TranslationBuilder(
                    builder: (context) => Text(
                      'coming_soon'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
