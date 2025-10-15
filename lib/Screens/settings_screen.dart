import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../utils/translation_helper.dart';
import '../widgets/language_selector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TranslationService _translationService = TranslationService();

  @override
  Widget build(BuildContext context) {
    return TranslationBuilder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('settings'.tr),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('language'.tr),
              subtitle: Text('select_language'.tr),
              trailing: const LanguageSelector(showAsDropdown: true),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text('notifications'.tr),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text('privacy'.tr),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text('terms'.tr),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text('help'.tr),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('about'.tr),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _translationService.clearCache();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('success'.tr)),
                        );
                      }
                    },
                    child: Text('clear_translation_cache'.tr),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('refreshing_translations'.tr)),
                      );
                      await _translationService.preloadLanguage(
                        _translationService.currentLanguage,
                        forceRefresh: true,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('success'.tr)),
                        );
                      }
                    },
                    child: Text('refresh_translations'.tr),
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
