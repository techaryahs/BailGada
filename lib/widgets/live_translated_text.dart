import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class LiveTranslatedText extends StatefulWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const LiveTranslatedText(
    this.textKey, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  State<LiveTranslatedText> createState() => _LiveTranslatedTextState();
}

class _LiveTranslatedTextState extends State<LiveTranslatedText> {
  final TranslationService _translationService = TranslationService();
  late final ValueNotifier<String> _textNotifier = ValueNotifier(
    _translationService.translate(widget.textKey)
  );

  @override
  void initState() {
    super.initState();
    _translationService.addListener(_onLanguageChanged);
    _loadTranslation();
  }

  @override
  void dispose() {
    _translationService.removeListener(_onLanguageChanged);
    _textNotifier.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    _loadTranslation();
  }

  Future<void> _loadTranslation() async {
    // Get immediate translation (manual or base text)
    final immediate = _translationService.translate(widget.textKey);
    _textNotifier.value = immediate;

    // Always try API translation if not in English and not already cached
    if (_translationService.currentLanguage != 'en') {
      // Check if we already have a good translation (not same as base text)
      final baseText = TranslationService.baseTexts[widget.textKey];
      final needsApiTranslation = baseText != null && immediate == baseText;
      
      if (needsApiTranslation || !_translationService.hasManualTranslation(widget.textKey)) {
        try {
          // Use API for translation with timeout
          final apiTranslated = await _translationService.translateAsync(widget.textKey)
              .timeout(const Duration(seconds: 5));
          if (apiTranslated != immediate) {
            _textNotifier.value = apiTranslated;
          }
        } catch (e) {
          // Keep the immediate translation if API fails
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _textNotifier,
      builder: (context, text, child) {
        return Text(
          text,
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
          softWrap: widget.softWrap,
        );
      },
    );
  }
}