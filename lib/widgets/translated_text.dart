import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class TranslatedText extends StatefulWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const TranslatedText(
    this.textKey, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String _translatedText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTranslation();
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    _loadTranslation();
  }

  Future<void> _loadTranslation() async {
    final translated = await TranslationService().translateAsync(widget.textKey);
    if (mounted) {
      setState(() {
        _translatedText = translated;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Text(
        TranslationService().translate(widget.textKey),
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
        softWrap: widget.softWrap,
      );
    }

    return Text(
      _translatedText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      softWrap: widget.softWrap,
    );
  }
}
