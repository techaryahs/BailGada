import 'dart:io';
import 'package:bailgada/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../utils/translation_helper.dart';
import 'event_registration_form.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  final String userKey;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.userKey,
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 Handle all possible key variations safely
    final String title = event["title"] ?? event["eventName"] ?? "untitled_event".tr;
    final String description = event["description"] ?? event["eventIntro"] ?? "no_description_available".tr;
    final String location = event["location"] ?? event["eventLocation"] ?? "location_not_specified".tr;
    final String hostName = event["hostName"] ?? "you_host".tr;
    final String? imagePath = event["image"] ?? event["eventBannerPath"];
    final String? hostImage = event["hostImage"] ?? "assets/images/default_profile.jpg";

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼️ Full-width Header Image
                Stack(
                  children: [
                    _buildEventImage(imagePath),

                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // 🧭 Title on Image
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 👤 Host Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: (hostImage != null && hostImage.startsWith("assets/"))
                            ? AssetImage(hostImage) as ImageProvider
                            : (hostImage != null && File(hostImage).existsSync())
                            ? FileImage(File(hostImage))
                            : const AssetImage("assets/images/default_profile.jpg"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hostName,
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.orangeAccent),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📄 Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🧾 Registration Prompt
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepOrange.withValues(alpha: 0.9),
                        Colors.orangeAccent.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.campaign_rounded, color: Colors.black, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ready_to_join".tr,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "register_now_message".tr,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🧡 Register Button
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventRegistrationForm(userKey: userKey, eventName: title)),
                      );
                    },
                    icon: const Icon(Icons.app_registration, color: Colors.black),
                    label: Text(
                      "register_now".tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // 🔙 Floating Back Button (Top-Left)
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(userKey: userKey),
                  ),
                );
              },

            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEventImage(String? imagePath) {
    try {
      if (imagePath != null && File(imagePath).existsSync()) {
        return Image.file(
          File(imagePath),
          width: double.infinity,
          height: 280,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/bailgada_poster.png",
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
            );
          },
        );
      } else {
        return Image.asset(
          "assets/images/bailgada_poster.png",
          width: double.infinity,
          height: 280,
          fit: BoxFit.cover,
        );
      }
    } catch (e) {
      return Image.asset(
        "assets/images/bailgada_poster.png",
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
      );
    }
  }

}
