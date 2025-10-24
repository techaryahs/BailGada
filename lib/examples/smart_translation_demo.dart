import 'package:flutter/material.dart';
import '../utils/translation_helper.dart';
import '../widgets/smart_text.dart';

/// Demo showing how SmartText automatically translates any English text
class SmartTranslationDemo extends StatelessWidget {
  const SmartTranslationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SmartText('Smart Translation Demo'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Using translation key
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SmartText(
                      'Translation Keys',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SmartText('home'),
                    const SmartText('profile'),
                    const SmartText('settings'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Example 2: Using plain English text
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SmartText(
                      'Plain English Text',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SmartText('Welcome to our app'),
                    const SmartText('This is a test message'),
                    const SmartText('Click here to continue'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Example 3: Using extension
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'Using Extension'.trSmart,
                    const SizedBox(height: 8),
                    'Hello World'.trSmart,
                    'Good Morning'.trSmart,
                    'Thank You'.trSmart,
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Example 4: Mixed content
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SmartText(
                      'Event Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SmartText('Event Name: Bull Cart Race'),
                    const SmartText('Location: Pune'),
                    const SmartText('Date: 25 December 2024'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How it works:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('1. SmartText detects if text is a translation key'),
                  const Text('2. If not a key, checks if it\'s English text'),
                  const Text('3. Automatically translates English text to current language'),
                  const Text('4. Caches translations for instant future use'),
                  const SizedBox(height: 8),
                  const Text(
                    'Change language in Settings to see it in action!',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.orange,
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
}
