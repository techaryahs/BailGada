import 'package:bailgada/host/Screens/event_creation_page.dart';
import 'package:flutter/material.dart';
import '../../widgets/host_event_category_bar.dart';
import '../../utils/translation_helper.dart';
import 'host_current_events.dart';
import 'host_past_events.dart';

class HostScreen extends StatefulWidget {
  final String userKey;
  const HostScreen({super.key, required this.userKey});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  int selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          HostTopNavigationBar(
            currentIndex: selectedIndex,
            onTabSelected: _onTabSelected,
          ),
          Expanded(
            child: selectedIndex == 0
                ? const HostCurrentEventsPage()
                : HostPastEventsPage(userKey: widget.userKey,),
          ),
        ],
      ),

      // 🎯 Floating Add Event Button
      // 🎯 Floating Add Event Button (Enhanced with Label)
      floatingActionButton: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCreationPage(),
            ),
          )
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6E40), Color(0xFFFF3D00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withValues(alpha: 0.6),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "add_event".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
