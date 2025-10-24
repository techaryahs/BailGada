import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../widgets/live_translated_text.dart';

class TranslationDebugScreen extends StatefulWidget {
  const TranslationDebugScreen({super.key});

  @override
  State<TranslationDebugScreen> createState() => _TranslationDebugScreenState();
}

class _TranslationDebugScreenState extends State<TranslationDebugScreen> {
  final TranslationService _translationService = TranslationService();
  Map<String, dynamic> _debugInfo = {};
  bool _isTestingApi = false;
  String _apiTestResult = '';

  @override
  void initState() {
    super.initState();
    _updateDebugInfo();
  }

  void _updateDebugInfo() {
    setState(() {
      _debugInfo = _translationService.getDebugInfo();
    });
  }

  Future<void> _testApi() async {
    setState(() {
      _isTestingApi = true;
      _apiTestResult = 'Testing...';
    });

    try {
      final isWorking = await _translationService.testApiConnectivity();
      setState(() {
        _apiTestResult = isWorking ? 'API is working!' : 'API test failed';
        _isTestingApi = false;
      });
    } catch (e) {
      setState(() {
        _apiTestResult = 'API test error: $e';
        _isTestingApi = false;
      });
    }
    
    _updateDebugInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation Debug'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test translations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Translations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildTranslationTest('home'),
                    _buildTranslationTest('top_racers'),
                    _buildTranslationTest('current_events'),
                    _buildTranslationTest('carousel_title_1'),
                    _buildTranslationTest('rohit_pawar'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Debug info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Debug Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...(_debugInfo.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('${entry.key}: ${entry.value}'),
                    ))),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateDebugInfo,
                      child: const Text('Refresh Debug Info'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // API test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(_apiTestResult),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isTestingApi ? null : _testApi,
                      child: Text(_isTestingApi ? 'Testing...' : 'Test API'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        _translationService.forceEnableApi();
                        _updateDebugInfo();
                        setState(() {
                          _apiTestResult = 'API force-enabled';
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Force Enable API'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Language controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Language Controls',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _translationService.changeLanguage('en');
                            _updateDebugInfo();
                          },
                          child: const Text('English'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            await _translationService.changeLanguage('mr');
                            _updateDebugInfo();
                          },
                          child: const Text('Marathi'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await _translationService.clearCache();
                        _updateDebugInfo();
                      },
                      child: const Text('Clear Cache'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationTest(String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(' → '),
          Expanded(
            child: LiveTranslatedText(
              key,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}