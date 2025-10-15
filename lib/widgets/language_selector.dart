import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../utils/translation_helper.dart';

class LanguageSelector extends StatefulWidget {
  final Function(String)? onLanguageChanged;
  final bool showAsDropdown;

  const LanguageSelector({
    super.key,
    this.onLanguageChanged,
    this.showAsDropdown = false,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final TranslationService _translationService = TranslationService();
  bool _isChangingLanguage = false;

  static const Map<String, String> _languageNames = {
    'mr': 'मराठी',
    'en': 'English',
  };

  Future<void> _changeLanguageWithAnimation(String lang, BuildContext context) async {
    setState(() {
      _isChangingLanguage = true;
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                    strokeWidth: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'changing_language'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _languageNames[lang] ?? lang,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Change language
    await _translationService.changeLanguage(lang);
    
    // Small delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog
      setState(() {
        _isChangingLanguage = false;
      });
      widget.onLanguageChanged?.call(lang);
    }
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_language'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...TranslationService.supportedLanguages.map((lang) {
              final isSelected = _translationService.currentLanguage == lang;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                ),
                title: Text(
                  _languageNames[lang] ?? lang,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected 
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
                onTap: _isChangingLanguage ? null : () async {
                  Navigator.pop(context);
                  await _changeLanguageWithAnimation(lang, context);
                },
              );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showAsDropdown) {
      return DropdownButton<String>(
        value: _translationService.currentLanguage,
        icon: const Icon(Icons.language),
        underline: Container(),
        items: TranslationService.supportedLanguages.map((lang) {
          return DropdownMenuItem(
            value: lang,
            child: Text(_languageNames[lang] ?? lang),
          );
        }).toList(),
        onChanged: _isChangingLanguage ? null : (String? newLang) async {
          if (newLang != null && mounted) {
            await _changeLanguageWithAnimation(newLang, context);
          }
        },
      );
    }

    return InkWell(
      onTap: _showLanguageBottomSheet,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language),
            const SizedBox(width: 8),
            Text(_languageNames[_translationService.currentLanguage] ?? _translationService.currentLanguage),
          ],
        ),
      ),
    );
  }
}
