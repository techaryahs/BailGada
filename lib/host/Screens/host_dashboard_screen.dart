import 'package:flutter/material.dart';

class HostDashboardScreen extends StatelessWidget {
  const HostDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.04;
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Bailgada Sharyat! 🐂',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                const Text(
                  'Manage your bullock cart racing events efficiently',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: size.height * 0.02),
                GridView.count(
                  crossAxisCount: size.width > 600 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: size.width > 600 ? 1.5 : 1,
                  children: [
                    _buildDashboardCard(
                      context,
                      icon: Icons.event_available,
                      title: 'Total Events',
                      value: '12',
                      color: const Color(0xFF6B8E23),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.pending_actions,
                      title: 'Pending Approvals',
                      value: '3',
                      color: const Color(0xFFFF8C00),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.people,
                      title: 'Active Participants',
                      value: '248',
                      color: const Color(0xFFD87B3A),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.directions_run,
                      title: 'Upcoming Races',
                      value: '5',
                      color: const Color(0xFF8B4513),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                const Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                _buildActivityCard('New event created: "Pune Championship 2025"', '2 hours ago'),
                _buildActivityCard('Participant registration approved', '5 hours ago'),
                _buildActivityCard('Sponsor added: Maharashtra Tourism', '1 day ago'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required Color color,
      }) {
    final size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        padding: EdgeInsets.all(size.width * 0.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: size.width * 0.08, color: Colors.white),
            SizedBox(height: size.height * 0.01),
            Text(
              value,
              style: TextStyle(
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.035,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFD87B3A),
          child: Icon(Icons.notifications, color: Colors.white, size: 20),
        ),
        title: Text(title),
        subtitle: Text(
          time,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
