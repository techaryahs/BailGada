import 'package:bailgada/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/bottombar.dart';
import '../widgets/event_category_bar.dart';
import '../widgets/live_translated_text.dart';
import '../widgets/dynamic_translated_text.dart';
import '../utils/marathi_utils.dart';
import 'events/current_events_page.dart';
import 'events/past_event_page.dart';
import 'events/upcoming_events_page.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userKey;

  const HomeScreen({
    super.key,
    required this.userKey,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0; // for carousel
  int _selectedIndex = 0; // for bottom nav
  String selectedCategory = 'Current';


  final List<Map<String, String>> _carouselItems = [
    {
      "image": "assets/images/bailgada_poster.png",
      "title": "carousel_title_1",
      "subtitle": "carousel_subtitle_1",
    },
    {
      "image": "assets/images/bailgada_poster.png",
      "title": "carousel_title_2",
      "subtitle": "carousel_subtitle_2",
    },
    {
      "image": "assets/images/bailgada_poster.png",
      "title": "carousel_title_3",
      "subtitle": "carousel_subtitle_3",
    },
  ];

  final List<Map<String, String>> events = [
    {
      "title": "🔥 Current Event",
      "subtitle": "BullCart Race 2025 - Live Now!",
      "image": "assets/images/bailgada_poster.png",
      "status": "LIVE",
    },
    {
      "title": "📅 Upcoming Event",
      "subtitle": "Summer Championship - Starts Soon",
      "image": "assets/images/bailgada_poster.png",
      "status": "UPCOMING",
    },
    {
      "title": "⏳ Past Event",
      "subtitle": "Winter Clash - Highlights Available",
      "image": "assets/images/bailgada_poster.png",
      "status": "ENDED",
    },
  ];

  // Home page content
  Widget _buildHomeContent() {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Carousel Section
            CarouselSlider.builder(
              key: const ValueKey('home_carousel'),
              itemCount: _carouselItems.length,
              options: CarouselOptions(
                height: screenHeight * 0.30, // responsive height
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  if (mounted) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }
                },
              ),
              itemBuilder: (context, index, realIndex) {
                final item = _carouselItems[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        item["image"]!,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LiveTranslatedText(
                              item["title"]!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            LiveTranslatedText(
                              item["subtitle"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 🔘 Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _carouselItems.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentIndex == entry.key ? 12 : 8,
                  height: 8,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? Colors.orange
                        : Colors.white54,
                  ),
                );
              }).toList(),
            ),

            EventCategoryBar(
              key: const ValueKey('event_category_bar'),
              selectedCategory: selectedCategory, // controlled by parent
              onCategoryChanged: (category) {
                if (mounted) {
                  setState(() {
                    selectedCategory = category;
                  });
                }
              },
            ),


            const SizedBox(height: 10),

            if (selectedCategory == 'Current')
              CurrentEventsPage(key: const ValueKey('current'), userKey: widget.userKey)
            else if (selectedCategory == 'Upcoming')
              UpcomingEventsPage(key: const ValueKey('upcoming'), userKey: widget.userKey)
            else
              PastEventsPage(key: const ValueKey('past'), userKey: widget.userKey),


            const SizedBox(height: 20),

            // 🏆 Top Racers Section
            // 🏁🔥 Top Racers (Interactive Leaderboard Preview)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "🏆 ",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const LiveTranslatedText(
                        "top_racers",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ⚡ Fancy Racer Cards
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutExpo,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A0E00),
                          // Color(0xFF3E1F00),
                          Color(0xFF5C2A00),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildCrazyRacerCard(
                          context,
                          rank: 1,
                          nameKey: "rohit_pawar",
                          image: "assets/images/bailgada_poster.png",
                          color: Colors.amberAccent,
                        ),
                        const SizedBox(height: 10),
                        _buildCrazyRacerCard(
                          context,
                          rank: 2,
                          nameKey: "suresh_patil",
                          image: "assets/images/bailgada_poster.png",
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10),
                        _buildCrazyRacerCard(
                          context,
                          rank: 3,
                          nameKey: "vikram_jadhav",
                          image: "assets/images/bailgada_poster.png",
                          color: Colors.brown.shade300,
                        ),

                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                            );
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.orangeAccent, Colors.deepOrange],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bar_chart, color: Colors.white),
                                SizedBox(width: 8),
                                LiveTranslatedText(
                                  "view_full_leaderboard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  // 🎟️ Event Bottom Bar Card Widget
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    final List<Widget> pages = [
      _buildHomeContent(),
      ProfileScreen(userKey: widget.userKey),

    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        key: const ValueKey('bottom_nav_bar'),
        selectedIndex: _selectedIndex,
        onTap: (index) {
          if (mounted) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),

    );
  }
}

Widget _buildCrazyRacerCard(BuildContext context,
    {required int rank,
      required String nameKey,
      required String image,
      required Color color}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.6),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.6), width: 1.2),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color.withOpacity(0.4), Colors.transparent],
                ),
              ),
            ),
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(image),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "#$rank",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: LiveTranslatedText(
            nameKey,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(color: Colors.orange, blurRadius: 8),
              ],
            ),
          ),
        ),
        const Icon(Icons.speed, color: Colors.orangeAccent, size: 20),
      ],
    ),
  );
}







