import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../widgets/live_translated_text.dart';
import '../widgets/smart_text.dart';

class Tr {
  static String get(String key) => TranslationService().translate(key);
  
  static Future<String> getAsync(String key) => TranslationService().translateAsync(key);
}

extension StringTranslationExt on String {
  String get tr => Tr.get(this);
  
  Future<String> get trAsync => Tr.getAsync(this);
  
  Widget get trLive => LiveTranslatedText(this);
  
  // Smart translation - auto-detects if it's a key or English text
  Widget get trSmart => SmartText(this);
}

class TranslationBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  
  const TranslationBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<TranslationBuilder> createState() => _TranslationBuilderState();
}

class _TranslationBuilderState extends State<TranslationBuilder> {
  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
