import 'package:flutter/material.dart';
import '../services/translation_service.dart';

/// Widget for translating dynamic text (like event names, descriptions)
/// that don't have predefined translation keys
class DynamicTranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const DynamicTranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  State<DynamicTranslatedText> createState() => _DynamicTranslatedTextState();
}

class _DynamicTranslatedTextState extends State<DynamicTranslatedText> {
  final TranslationService _translationService = TranslationService();
  late final ValueNotifier<String> _textNotifier = ValueNotifier(widget.text);

  @override
  void initState() {
    super.initState();
    _translationService.addListener(_onLanguageChanged);
    _loadTranslation();
  }

  @override
  void didUpdateWidget(DynamicTranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _textNotifier.value = widget.text;
      _loadTranslation();
    }
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
    // Show original text immediately
    _textNotifier.value = widget.text;

    // If English, no translation needed
    if (_translationService.currentLanguage == 'en') {
      return;
    }

    // Try to translate using API with shorter timeout
    try {
      final translated = await _translationService
          .translateDynamicText(widget.text)
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              // Return original text on timeout
              return widget.text;
            },
          );
      
      _textNotifier.value = translated;
    } catch (e) {
      // Keep original text if translation fails
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
