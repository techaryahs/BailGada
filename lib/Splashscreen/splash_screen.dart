import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/home_screen.dart';
import '../auth/signin.dart';
import '../host/Screens/dashboard_page.dart';
import '../services/translation_service.dart';
import '../widgets/live_translated_text.dart';

class SplashScreen extends StatefulWidget {
  final String userKey;
  const SplashScreen({super.key, required this.userKey});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();

    // Initialize translation service
    _initializeTranslations();

    // 🎞️ Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // ⏳ Navigate after 3 seconds
    Timer(const Duration(seconds: 3), _checkLoginStatus);
  }

  Future<void> _initializeTranslations() async {
    await _translationService.initialize();
    await _translationService.loadLanguagePreference();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    String userKey = prefs.getString("userKey") ?? "";
    bool isHost = prefs.getBool("isHost") ?? false;

    // Debug: isLoggedIn=$isLoggedIn, userKey=$userKey, isHost=$isHost

    if (!mounted) return;

    if (isLoggedIn && userKey.isNotEmpty) {
      // Check if user is host
      if (isHost) {
        // Navigate to Host Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage(userKey: widget.userKey,)),
        );
      } else {
        // Navigate to regular Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(userKey: userKey)),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignIn(userKey:  widget.userKey,)),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFFff6f00)], // black → orange
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports_motorsports,
                  size: 100, color: Colors.orangeAccent),
              const SizedBox(height: 20),

              const LiveTranslatedText(
                "bailgada_race",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),

              const LiveTranslatedText(
                "ride_the_speed",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
