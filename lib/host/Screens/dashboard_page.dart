import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../utils/translation_helper.dart';
import '../../auth/signin.dart';
import 'host_dashboard_screen.dart';
import 'host_payment_screen.dart';
import 'host_screen.dart';

class DashboardPage extends StatefulWidget {
  final String userKey;
  const DashboardPage({super.key, required this.userKey});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const HostDashboardScreen(),
    HostScreen(userKey: widget.userKey,),
    const HostPaymentScreen(),
  ];

  Future<void> _showLogoutDialog() async {
    if (!mounted) return;
    
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: TranslationBuilder(
            builder: (context) => Text(
              'confirm_logout'.tr,
              style: const TextStyle(
                color: Color(0xFFFF9800),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: TranslationBuilder(
            builder: (context) => Text(
              'logout_confirmation'.tr,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          actions: <Widget>[
            TranslationBuilder(
              builder: (context) => TextButton(
                child: Text(
                  'cancel'.tr,
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ),
            TranslationBuilder(
              builder: (context) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'logout'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool("isLoggedIn", false);
                  await prefs.setString("userKey", "");
                  await prefs.setString("userEmail", "");
                  await prefs.setBool("isHost", false);
                  
                  if (!mounted) return;
                  Navigator.of(dialogContext).pop(); // Close dialog
                  // Navigate to sign in page
                  if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignIn(userKey:  widget.userKey,)),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double emojiFontSize = screenWidth * 0.06;
    final double titleFontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🏁 ',
              style: TextStyle(fontSize: emojiFontSize),
            ),
            Text(
              'host_dashboard'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF9800),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
