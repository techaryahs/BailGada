import 'package:flutter/material.dart';
import '../../utils/translation_helper.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationBuilder(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'driver_dashboard'.tr,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚜 Driver Intro Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.drive_eta, color: Colors.black, size: 30),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Welcome, Driver! Track your races and performance here.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🧭 Quick Actions
            const Text(
              "Quick Actions",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.assignment_outlined,
                  title: 'my_races'.tr,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('my_races'.tr),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.timer,
                  title: 'race_history'.tr,
                  onTap: () {},
                ),
                _buildActionCard(
                  context,
                  icon: Icons.analytics,
                  title: 'event_analytics'.tr,
                  onTap: () {},
                ),
                _buildActionCard(
                  context,
                  icon: Icons.directions_car,
                  title: 'driver'.tr,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 📊 Stats Section
            const Text(
              "Performance Overview",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildStatsCard(
              context,
              icon: Icons.star,
              label: 'total_races_completed'.tr,
              value: "28",
            ),
            const SizedBox(height: 12),
            _buildStatsCard(
              context,
              icon: Icons.emoji_events,
              label: 'races_won'.tr,
              value: "11",
            ),
            const SizedBox(height: 12),
            _buildStatsCard(
              context,
              icon: Icons.speed,
              label: 'average_speed'.tr,
              value: "65 km/h",
            ),
            const SizedBox(height: 12),
            _buildStatsCard(
              context,
              icon: Icons.attach_money,
              label: 'total_earnings'.tr,
              value: "₹1.5L",
            ),
          ],
        ),
      ),
      ),
    );
  }

  /// 🧱 Helper Widget: Action Card
  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          border: Border.all(color: Colors.orange, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orange, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 Helper Widget: Stats Card
  Widget _buildStatsCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.orange, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}