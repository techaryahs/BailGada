import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../widgets/live_translated_text.dart';
import '../../widgets/dynamic_translated_text.dart';
import '../../utils/translation_helper.dart';
import '../../utils/marathi_utils.dart';
import '../event_details_screen.dart';

class PastEventsPage extends StatefulWidget {
  final String userKey;

  const PastEventsPage({super.key, required this.userKey});

  @override
  State<PastEventsPage> createState() => _PastEventsPageState();
}

class _PastEventsPageState extends State<PastEventsPage> with AutomaticKeepAliveClientMixin {
  final DatabaseReference _eventsRef =
  FirebaseDatabase.instance.ref().child('events');
  
  List<Map<String, dynamic>> _cachedEvents = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    try {
      final snapshot = await _eventsRef.once();
      if (!mounted) return;
      
      if (snapshot.snapshot.value == null) {
        setState(() {
          _cachedEvents = [];
          _isLoading = false;
        });
        return;
      }

      final data = Map<dynamic, dynamic>.from(snapshot.snapshot.value as Map);
      final allEvents = data.entries.map((e) {
        return Map<String, dynamic>.from(e.value);
      }).toList();

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

      if (mounted) {
        setState(() {
          _cachedEvents = pastEvents;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }

    if (_hasError) {
      return const Center(
        child: LiveTranslatedText(
          "error_loading_past_events",
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (_cachedEvents.isEmpty) {
      return const Center(
        child: LiveTranslatedText(
          "no_past_events",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return SingleChildScrollView(
      key: const ValueKey('past_events_scroll'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "⏳ ",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.orange, blurRadius: 2)],
                ),
              ),
              const LiveTranslatedText(
                "past_events",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.orange, blurRadius: 2)],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._cachedEvents.map((event) => _buildPastEventCard(event)),
        ],
      ),
    );
  }

  Widget _buildPastEventCard(Map<String, dynamic> event) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(event: event, userKey: widget.userKey,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 Poster Image
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
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    child: DynamicTranslatedText(
                      event["eventName"] ?? "untitled_event".tr,
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

            // 🏆 Event Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event["eventIntro"] != null)
                    DynamicTranslatedText(
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
                          size: 14, color: Colors.orangeAccent),
                      const SizedBox(width: 6),
                      Text(
                        MarathiUtils.formatDate(event["eventDate"]),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.orangeAccent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: DynamicTranslatedText(
                          event["eventLocation"] ?? "unknown_location".tr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                        colors: [Colors.grey, Colors.blueGrey],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const LiveTranslatedText(
                      "ended",
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
          ],
        ),
      ),
    );
  }
}
