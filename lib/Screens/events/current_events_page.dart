import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../widgets/live_translated_text.dart';
import '../../widgets/dynamic_translated_text.dart';
import '../../utils/translation_helper.dart';
import '../event_details_screen.dart';

class CurrentEventsPage extends StatefulWidget {
  final String userKey;
  const CurrentEventsPage({
    super.key,
    required this.userKey});

  @override
  State<CurrentEventsPage> createState() => _CurrentEventsPageState();
}

class _CurrentEventsPageState extends State<CurrentEventsPage> with AutomaticKeepAliveClientMixin {
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

      final currentEvents = allEvents.where((event) {
        if (event['eventDate'] == null) return false;
        try {
          final date = DateTime.parse(event['eventDate']);
          final eventDay = DateTime(date.year, date.month, date.day);
          return eventDay.isAtSameMomentAs(today);
        } catch (_) {
          return false;
        }
      }).toList();

      if (mounted) {
        setState(() {
          _cachedEvents = currentEvents;
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
          "error_loading_events",
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (_cachedEvents.isEmpty) {
      return const Center(
        child: LiveTranslatedText(
          "no_ongoing_upcoming_events",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      key: const ValueKey('current_events_scroll'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "🔥 ",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: Colors.orangeAccent, blurRadius: 1),
                  ],
                ),
              ),
              const LiveTranslatedText(
                "current_events",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: Colors.orangeAccent, blurRadius: 1),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._cachedEvents.map((event) => _buildEventCard(context, event)),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
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
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
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
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
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
                    child: DynamicTranslatedText(
                      event["eventName"] ?? "untitled_event".tr,
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
                        Text(
                          event["eventName"] ?? "unknown_host".tr,
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
                              child: DynamicTranslatedText(
                                event["eventLocation"] ?? "unknown_location".tr,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.redAccent, Colors.red],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const LiveTranslatedText(
                      "live",
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
            if (event["eventIntro"] != null)
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: DynamicTranslatedText(
                  event["eventIntro"],
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
