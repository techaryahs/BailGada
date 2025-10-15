import 'package:flutter/material.dart';
import '../utils/translation_helper.dart';

/// Navigation buttons widget that displays the three main navigation options
/// as shown in the app screenshots: Current Event, Upcoming Program, Past Time
class NavigationButtons extends StatelessWidget {
  final Function(String)? onButtonPressed;

  const NavigationButtons({
    super.key,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TranslationBuilder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: _buildNavButton(
                context,
                icon: Icons.home,
                text: 'current_event'.tr,
                onTap: () => onButtonPressed?.call('current'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildNavButton(
                context,
                icon: Icons.event_available,
                text: 'upcoming_program'.tr,
                isActive: true, // This button appears active in the screenshot
                onTap: () => onButtonPressed?.call('upcoming'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildNavButton(
                context,
                icon: Icons.history,
                text: 'past_time'.tr,
                onTap: () => onButtonPressed?.call('past'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.withOpacity(0.2) : Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? Colors.green : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.green : Colors.white70,
              size: 16,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.white70,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}