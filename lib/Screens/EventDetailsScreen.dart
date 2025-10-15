import 'dart:io';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // 🔹 Handle all possible key variations safely
    final String title = event["title"] ?? event["eventName"] ?? "Untitled Event";
    final String description = event["description"] ?? event["eventIntro"] ?? "No description available.";
    final String location = event["location"] ?? event["eventLocation"] ?? "Location not specified";
    final String hostName = event["hostName"] ?? "You (Host)";
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
                    imagePath != null && File(imagePath).existsSync()
                        ? Image.file(
                      File(imagePath),
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      "assets/images/bailgada_poster.png",
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
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
                        Colors.deepOrange.withOpacity(0.9),
                        Colors.orangeAccent.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.4),
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
                          children: const [
                            Text(
                              "Ready to Join the Race?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Register now to confirm your participation in this event!",
                              style: TextStyle(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Registration feature coming soon!"),
                          backgroundColor: Colors.deepOrangeAccent,
                        ),
                      );
                    },
                    icon: const Icon(Icons.app_registration, color: Colors.black),
                    label: const Text(
                      "Register Now",
                      style: TextStyle(
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
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orangeAccent, width: 1.2),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.orangeAccent, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
