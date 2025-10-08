import 'package:flutter/material.dart';

/// 🎯 EventCategoryBar Widget
/// Displays a top navigation bar with tabs:
/// 🔸 Current Events | 🔹 Upcoming Events | ⚫ Past Events
///
/// Use it like:
/// ```dart
/// EventCategoryBar(
///   onCategoryChanged: (category) {
///     print("Selected: $category");
///   },
/// )
/// ```

class EventCategoryBar extends StatefulWidget {
  final Function(String) onCategoryChanged;
  final String initialCategory;

  const EventCategoryBar({
    super.key,
    required this.onCategoryChanged,
    this.initialCategory = 'Current',
  });

  @override
  State<EventCategoryBar> createState() => _EventCategoryBarState();
}

class _EventCategoryBarState extends State<EventCategoryBar> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialCategory;
  }

  @override
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
            color: Colors.brown.withOpacity(0.2),
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
            _buildTabButton('Current', Icons.local_fire_department, Colors.orange),
            const SizedBox(width: 12),
            _buildTabButton('Upcoming', Icons.event_available_rounded, Colors.green),
            const SizedBox(width: 12),
            _buildTabButton('Past', Icons.history, Colors.grey),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }


  Widget _buildTabButton(String label, IconData icon, Color activeColor) {
    final bool isSelected = selected == label;

    return GestureDetector(
      onTap: () {
        setState(() => selected = label);
        widget.onCategoryChanged(label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : Colors.white24,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}