import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class HostTopNavigationBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const HostTopNavigationBar({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  State<HostTopNavigationBar> createState() => _HostTopNavigationBarState();
}

class _HostTopNavigationBarState extends State<HostTopNavigationBar> {
  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();
    _translationService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _translationService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(color: Colors.deepOrangeAccent, width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrangeAccent,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem(
            index: 0,
            icon: Icons.flash_on_rounded,
            labelKey: "current_events",
          ),
          _buildTabItem(
            index: 1,
            icon: Icons.history_rounded,
            labelKey: "past_events",
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String labelKey,
  }) {
    bool isSelected = widget.currentIndex == index;

    return InkWell(
      onTap: () => widget.onTabSelected(index),
      borderRadius: BorderRadius.circular(10),
      splashColor: Colors.deepOrangeAccent.withValues(alpha: 0.2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: isSelected
              ? const LinearGradient(
            colors: [
              Color(0xFFFF6E40),
              Color(0xFFFF3D00),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white54,
              size: isSelected ? 26 : 22,
            ),
            const SizedBox(height: 4),
            Text(
              _translationService.translate(labelKey),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2,
              width: isSelected ? 40 : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
