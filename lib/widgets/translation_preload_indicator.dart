import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class TranslationPreloadIndicator extends StatefulWidget {
  final Widget child;
  
  const TranslationPreloadIndicator({
    super.key,
    required this.child,
  });

  @override
  State<TranslationPreloadIndicator> createState() => _TranslationPreloadIndicatorState();
}

class _TranslationPreloadIndicatorState extends State<TranslationPreloadIndicator> {
  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();
    _translationService.addListener(_onPreloadUpdate);
  }

  @override
  void dispose() {
    _translationService.removeListener(_onPreloadUpdate);
    super.dispose();
  }

  void _onPreloadUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_translationService.isPreloading) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade700,
                    Colors.orange.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Loading translations...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${(_translationService.preloadProgress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _translationService.preloadProgress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
