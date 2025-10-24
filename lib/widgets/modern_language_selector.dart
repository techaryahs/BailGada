import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../utils/translation_helper.dart';

class ModernLanguageSelector extends StatefulWidget {
  final Function(String)? onLanguageChanged;
  final bool showAsBottomSheet;
  final bool showAsDialog;

  const ModernLanguageSelector({
    super.key,
    this.onLanguageChanged,
    this.showAsBottomSheet = false,
    this.showAsDialog = false,
  });

  @override
  State<ModernLanguageSelector> createState() => _ModernLanguageSelectorState();
}

class _ModernLanguageSelectorState extends State<ModernLanguageSelector>
    with TickerProviderStateMixin {
  final TranslationService _translationService = TranslationService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isChangingLanguage = false;

  static const Map<String, String> _languageNames = {
    'mr': 'मराठी',
    'en': 'English',
  };

  static const Map<String, IconData> _languageIcons = {
    'mr': Icons.translate,
    'en': Icons.language,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
    
    // Listen to translation service changes
    _translationService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _translationService.removeListener(_onLanguageChanged);
    _animationController.dispose();
    super.dispose();
  }
  
  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _changeLanguageWithAnimation(String lang, BuildContext context) async {
    if (_isChangingLanguage) return;
    
    setState(() {
      _isChangingLanguage = true;
    });

    try {
      // Change language immediately
      await _translationService.changeLanguage(lang);
      
      // Force rebuild by calling setState after language change
      if (mounted) {
        setState(() {});
        
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Language changed to ${_languageNames[lang]}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFFF6B35),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        widget.onLanguageChanged?.call(lang);
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('failed_to_change_language'.tr),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChangingLanguage = false;
        });
      }
    }
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TranslationBuilder(
                    builder: (context) => Text(
                      'select_language'.tr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Language options
            ...TranslationService.supportedLanguages.map((lang) {
              final isSelected = _translationService.currentLanguage == lang;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _isChangingLanguage ? null : () async {
                      if (isSelected) {
                        Navigator.pop(context);
                        return;
                      }
                      Navigator.pop(context);
                      await _changeLanguageWithAnimation(lang, context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: isSelected 
                          ? const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                        color: isSelected ? null : Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ] : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? Colors.white.withValues(alpha: 0.2)
                                : const Color(0xFFFF6B35).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _languageIcons[lang] ?? Icons.language,
                              color: isSelected ? Colors.white : const Color(0xFFFF6B35),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _languageNames[lang] ?? lang,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isSelected 
                                  ? Colors.white
                                  : const Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 16),
            
            // Loading indicator
            if (_translationService.isPreloading)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TranslationBuilder(
                      builder: (context) => Text(
                        'loading'.tr,
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showAsBottomSheet) {
      return AnimatedBuilder(
        animation: _scaleAnimation,
        child: InkWell(
          onTap: _showLanguageBottomSheet,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  _languageNames[_translationService.currentLanguage] ?? 
                  _translationService.currentLanguage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
      );
    }

    // Default compact button
    return AnimatedBuilder(
      animation: _scaleAnimation,
      child: InkWell(
        onTap: _showLanguageBottomSheet,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 20),
              const SizedBox(width: 8),
              Text(_languageNames[_translationService.currentLanguage] ?? 
                   _translationService.currentLanguage),
            ],
          ),
        ),
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
    );
  }
}