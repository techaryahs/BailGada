import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class EventFormPreviewPage extends StatelessWidget {
  final Map<String, dynamic> formData;
  final String eventName;
  final String userKey;

  const EventFormPreviewPage({
    super.key,
    required this.userKey,
    required this.formData,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Form Preview",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Registration Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Details
            _buildDetailRow("Participant ID", formData["participantKey"] ?? "N/A"),
            _buildDetailRow("Name", formData["name"] ?? "N/A"),
            _buildDetailRow("Phone", formData["phone"] ?? "N/A"),

            const Divider(height: 30, thickness: 1, color: Colors.black26),

            const Text(
              "OX Pair Details",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            _buildDetailRow("1st OX Name", formData["ox1"] ?? "N/A"),
            _buildDetailRow("2nd OX Name", formData["ox2"] ?? "N/A"),

            const Divider(height: 30, thickness: 1, color: Colors.black26),

            _buildDetailRow("Payment Status", formData["paymentStatus"] ?? "Pending"),
            _buildDetailRow(
              "Submitted On",
              formData["timestamp"] != null
                  ? DateTime.parse(formData["timestamp"])
                  .toLocal()
                  .toString()
                  .split(".")
                  .first
                  : "N/A",
            ),

            const Spacer(),

            // 🏁 Back Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsScreen(
                        event: {"eventName": eventName},
                        userKey: userKey,
                      ),
                    ),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text(
                  "Back to Event",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.black54,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}