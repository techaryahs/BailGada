import 'package:flutter/material.dart';
import '../utils/translation_helper.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/language_selector.dart';

/// Demo screen showing how to properly implement multilingual support
/// This demonstrates the navigation buttons from the screenshots with proper translation
class MultilingualDemoScreen extends StatefulWidget {
  const MultilingualDemoScreen({super.key});

  @override
  State<MultilingualDemoScreen> createState() => _MultilingualDemoScreenState();
}

class _MultilingualDemoScreenState extends State<MultilingualDemoScreen> {
  String selectedSection = 'upcoming';

  @override
  Widget build(BuildContext context) {
    return TranslationBuilder(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('multilingual_demo'.tr),
          backgroundColor: Colors.orange,
          actions: const [
            LanguageSelector(),
            SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            // Navigation buttons as shown in screenshots
            NavigationButtons(
              onButtonPressed: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // Content area
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return TranslationBuilder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getSectionTitle(),
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Example event card
            _buildExampleEventCard(),
            
            const SizedBox(height: 20),
            
            // Translation examples
            _buildTranslationExamples(),
          ],
        ),
      ),
    );
  }

  String _getSectionTitle() {
    switch (selectedSection) {
      case 'current':
        return 'current_events'.tr;
      case 'upcoming':
        return 'upcoming_events'.tr;
      case 'past':
        return 'past_events'.tr;
      default:
        return 'events'.tr;
    }
  }

  Widget _buildExampleEventCard() {
    return TranslationBuilder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arshd', // Example event name from screenshot
              style: const TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'grdeqdegss', // Example description from screenshot
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Text(
                  '2025-10-24',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'coming_soon'.tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationExamples() {
    return TranslationBuilder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translation Examples:',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTranslationExample('home', 'home'.tr),
            _buildTranslationExample('events', 'events'.tr),
            _buildTranslationExample('settings', 'settings'.tr),
            _buildTranslationExample('leaderboard', 'leaderboard'.tr),
            _buildTranslationExample('coming_soon', 'coming_soon'.tr),
            _buildTranslationExample('live', 'live'.tr),
            _buildTranslationExample('ended', 'ended'.tr),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationExample(String key, String translation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$key: ',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            translation,
            style: const TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      ),
    );
  }
}