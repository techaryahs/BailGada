import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../utils/translation_helper.dart';
import '../../utils/marathi_utils.dart';

class HostDashboardScreen extends StatelessWidget {
  const HostDashboardScreen({super.key});

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
                child: Text(
                  '🏁 ${"bailgada_host_dashboard".tr}',
                  style: const TextStyle(
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
                  'welcome_back_host'.tr,
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
                      context,
                      icon: Icons.event_available,
                      titleKey: 'total_events',
                      value: '12',
                      color1: const Color(0xFFFFB74D),
                      color2: const Color(0xFFFF9800),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.pending_actions,
                      titleKey: 'pending_approvals',
                      value: '3',
                      color1: const Color(0xFFFFD54F),
                      color2: const Color(0xFFFFB300),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.people_alt_rounded,
                      titleKey: 'participants',
                      value: '248',
                      color1: const Color(0xFFFFAB91),
                      color2: const Color(0xFFFF7043),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.flag_circle_rounded,
                      titleKey: 'upcoming_races',
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
                        color: Colors.orangeAccent.withValues(alpha: 0.2),
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
                            Text(
                              "${"next_big_event".tr} 🔥",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${'kolhapur_bull_power'.tr} - ${MarathiUtils.formatDate(DateTime.now().add(const Duration(days: 7)).toIso8601String())}",
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
                child: Text(
                  "recent_activities".tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildActivityTile(
                Icons.add_circle,
                "new_event_created".tr,
                "2 ${'hours_ago'.tr}",
              ),
              _buildActivityTile(
                Icons.person_add_alt_1,
                "new_participant_registered".tr,
                "5 ${'hours_ago'.tr}",
              ),
              _buildActivityTile(
                Icons.monetization_on_rounded,
                "sponsor_added".tr,
                "1 ${'day_ago'.tr}",
              ),
              _buildActivityTile(
                Icons.verified,
                "event_approved".tr,
                "2 ${'days_ago'.tr}",
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
                    Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text("bulls_glory_quote".tr,
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
                        "bailgada_team".tr,
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

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String titleKey,
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
            color: color2.withValues(alpha: 0.3),
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
            MarathiUtils.convertToMarathiNumber(value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titleKey.tr,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
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
          border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
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
            backgroundColor: Colors.orangeAccent.withValues(alpha: 0.9),
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
