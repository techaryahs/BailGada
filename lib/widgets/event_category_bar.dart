import 'package:flutter/material.dart';

class EventCategoryBar extends StatelessWidget {
  final Function(String) onCategoryChanged;
  final String selectedCategory;

  const EventCategoryBar({
    super.key,
    required this.onCategoryChanged,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            const SizedBox(width: 12),
            _buildTabButton(context, 'Current', Icons.local_fire_department, Colors.orange),
            const SizedBox(width: 12),
            _buildTabButton(context, 'Upcoming', Icons.event_available_rounded, Colors.green),
            const SizedBox(width: 12),
            _buildTabButton(context, 'Past', Icons.history, Colors.grey),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String label, IconData icon, Color activeColor) {
    final bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () => onCategoryChanged(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : Colors.white24,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
