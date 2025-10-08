import 'package:flutter/material.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Host Dashboard",
          style: TextStyle(
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
            // 🧾 Header Info
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
                    child: Icon(Icons.groups, color: Colors.black, size: 30),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Welcome, Host! Manage your races and participants here.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🗂 Quick Actions Section
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
                  icon: Icons.add_circle_outline,
                  title: "Create Event",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Create Event clicked!"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.event,
                  title: "My Events",
                  onTap: () {},
                ),
                _buildActionCard(
                  context,
                  icon: Icons.people,
                  title: "Applications",
                  onTap: () {},
                ),
                _buildActionCard(
                  context,
                  icon: Icons.payments,
                  title: "Payments",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 📊 Analytics Section
            const Text(
              "Analytics Overview",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildAnalyticsCard(
              icon: Icons.trending_up,
              label: "Total Events Hosted",
              value: "12",
            ),
            const SizedBox(height: 12),
            _buildAnalyticsCard(
              icon: Icons.attach_money,
              label: "Total Revenue",
              value: "₹2.8L",
            ),
            const SizedBox(height: 12),
            _buildAnalyticsCard(
              icon: Icons.people_alt,
              label: "Active Participants",
              value: "350",
            ),
          ],
        ),
      ),
    );
  }

  /// 🧱 Helper Widget: Quick Action Card
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

  /// 📊 Helper Widget: Analytics Card
  Widget _buildAnalyticsCard({
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