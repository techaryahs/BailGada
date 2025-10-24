import 'package:flutter/material.dart';
import '../services/translation_service.dart';

/// Smart text widget that automatically detects and translates English text
/// Works with both predefined keys and dynamic content
class SmartText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const SmartText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  State<SmartText> createState() => _SmartTextState();
}

class _SmartTextState extends State<SmartText> {
  String _displayText = '';
  final TranslationService _translationService = TranslationService();
  DateTime? _lastTranslationAttempt;
  static const _translationDebounce = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _loadTranslation();
    _translationService.addListener(_onLanguageChanged);
  }

  @override
  void didUpdateWidget(SmartText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _loadTranslation();
    }
  }

  @override
  void dispose() {
    _translationService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    _loadTranslation();
  }

  Future<void> _loadTranslation() async {
    // Debounce rapid translation requests
    final now = DateTime.now();
    if (_lastTranslationAttempt != null) {
      final timeSinceLastAttempt = now.difference(_lastTranslationAttempt!);
      if (timeSinceLastAttempt < _translationDebounce) {
        // Too soon, skip this translation
        return;
      }
    }
    _lastTranslationAttempt = now;
    
    // Show original text immediately
    if (mounted) {
      setState(() {
        _displayText = widget.text;
      });
    }

    // If English, no translation needed
    if (_translationService.currentLanguage == 'en') {
      return;
    }

    // Try to get translation
    try {
      String translated = widget.text;
      
      // First, check if it's a translation key
      final keyTranslation = _translationService.translate(widget.text);
      if (keyTranslation != widget.text) {
        // It's a valid key, use the translation
        translated = keyTranslation;
      } else {
        // Not a key, check if it's English text that needs translation
        if (_isEnglishText(widget.text)) {
          // Translate as dynamic text with timeout
          translated = await _translationService
              .translateDynamicText(widget.text)
              .timeout(
                const Duration(seconds: 10),
                onTimeout: () => widget.text,
              );
        }
      }
      
      if (mounted) {
        setState(() {
          _displayText = translated;
        });
      }
    } catch (e) {
      // Keep original text on error
    }
  }

  // Improved heuristic to detect meaningful English text
  bool _isEnglishText(String text) {
    if (text.isEmpty || text.length < 3) return false;
    
    // Skip if it's mostly numbers or special characters
    final alphaChars = text.runes.where((rune) {
      return (rune >= 65 && rune <= 90) || // A-Z
             (rune >= 97 && rune <= 122); // a-z
    }).length;
    
    // Must have at least 50% alphabetic characters
    if (alphaChars < text.length * 0.5) return false;
    

    
    // Skip random strings (no vowels or too many consonants in a row)
    final hasVowels = text.toLowerCase().contains(RegExp(r'[aeiou]'));
    if (!hasVowels && text.length > 5) return false;
    
    // Skip if it looks like a random string (too many consonants)
    final consonantPattern = RegExp(r'[bcdfghjklmnpqrstvwxyz]{6,}', caseSensitive: false);
    if (consonantPattern.hasMatch(text)) return false;
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      softWrap: widget.softWrap,
    );
  }
}
