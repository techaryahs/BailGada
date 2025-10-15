import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

class HostDashboardScreen extends StatelessWidget {
  const HostDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏁 Header
              FadeInDown(
                duration: const Duration(milliseconds: 700),
                child: const Text(
                  '🏁 Bailgada Host Dashboard',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeIn(
                duration: const Duration(milliseconds: 900),
                child: Text(
                  'Welcome back, Shivaji! Manage your races, participants & sponsors efficiently.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 🟠 Dashboard Stats
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: GridView.count(
                  crossAxisCount: size.width > 600 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: size.width > 600 ? 1.5 : 1,
                  children: [
                    _buildDashboardCard(
                      icon: Icons.event_available,
                      title: 'Total Events',
                      value: '12',
                      color1: const Color(0xFFFFB74D),
                      color2: const Color(0xFFFF9800),
                    ),
                    _buildDashboardCard(
                      icon: Icons.pending_actions,
                      title: 'Pending Approvals',
                      value: '3',
                      color1: const Color(0xFFFFD54F),
                      color2: const Color(0xFFFFB300),
                    ),
                    _buildDashboardCard(
                      icon: Icons.people_alt_rounded,
                      title: 'Participants',
                      value: '248',
                      color1: const Color(0xFFFFAB91),
                      color2: const Color(0xFFFF7043),
                    ),
                    _buildDashboardCard(
                      icon: Icons.flag_circle_rounded,
                      title: 'Upcoming Races',
                      value: '5',
                      color1: const Color(0xFFFFCC80),
                      color2: const Color(0xFFFFB74D),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 🏆 Next Event Highlight
              FadeInLeft(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orangeAccent.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          size: 50, color: Colors.orange),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Next Big Event 🔥",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Kolhapur Bull Power Challenge - ${DateFormat('d MMM yyyy').format(DateTime.now().add(const Duration(days: 7)))}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 🕓 Recent Activities
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: const Text(
                  "Recent Activities",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildActivityTile(
                Icons.add_circle,
                "New Event Created: Pune Championship 2025",
                "2 hours ago",
              ),
              _buildActivityTile(
                Icons.person_add_alt_1,
                "New Participant Registered",
                "5 hours ago",
              ),
              _buildActivityTile(
                Icons.monetization_on_rounded,
                "Sponsor Added: Maharashtra Tourism",
                "1 day ago",
              ),
              _buildActivityTile(
                Icons.verified,
                "Event Approved: Sangli Rural Fest",
                "2 days ago",
              ),
              const SizedBox(height: 40),

              // ✨ Inspirational Footer
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border:
                    Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "“The power of your bulls defines the glory of your race.”",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "- Bailgada Sharyat Team",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color1,
    required Color color2,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color2.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 34, color: Colors.white),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(IconData icon, String title, String time) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orangeAccent.withOpacity(0.9),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            time,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
