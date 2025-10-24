import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../host/Screens/dashboard_page.dart';
import 'my_bail_ox_screen.dart';
import '../widgets/modern_language_selector.dart';
import '../widgets/live_translated_text.dart';
import '../utils/translation_helper.dart';
import '../auth/signin.dart';

class ProfileScreen extends StatefulWidget {
  final String userKey;

  const ProfileScreen({
    super.key,
    required this.userKey,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  String? phone;
  String? profileImage; // optional, stored as a URL/path
  
  // Predefined host email
  static const String hostEmail = 'Host@gmail.com';
  
  // Check if current user is host
  bool get isHost => email?.toLowerCase() == hostEmail.toLowerCase();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }


  void _fetchUserData() async {
    final dbRef =
    FirebaseDatabase.instance.ref("bailGada/users/${widget.userKey}");
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        name = data["name"];
        email = data["email"];
        phone = data["phone"];
        profileImage = data["profileImage"]; // optional field
      });
    }
  }

  /// 🔘 Logout confirmation popup
  Future<void> _showLogoutDialog() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: TranslationBuilder(
            builder: (context) => Text(
              'confirm_logout'.tr,
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
          content: TranslationBuilder(
            builder: (context) => Text(
              'logout_confirmation'.tr,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          actions: <Widget>[
            TranslationBuilder(
              builder: (context) => TextButton(
                child: Text('cancel'.tr, style: const TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ),
            TranslationBuilder(
              builder: (context) => ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: Text('logout'.tr, style: const TextStyle(color: Colors.white)),
                onPressed: () async {
                  await prefs.setBool("isLoggedIn", false);
                  await prefs.setString("userKey", "");
                  await prefs.setString("userEmail", "");
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
    return TranslationBuilder(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: LiveTranslatedText(
          'profile',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: name == null
          ? const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // 🖼️ Profile Picture + Info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.orange,
                    backgroundImage: profileImage != null
                        ? NetworkImage(profileImage!)
                        : null,
                    child: profileImage == null
                        ? const Icon(Icons.person,
                        size: 80, color: Colors.black)
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name ?? "",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email ?? "",
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    phone ?? "",
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    onPressed: () {
                      // TODO: Navigate to Edit Profile
                    },
                    child: LiveTranslatedText(
                      'edit_profile',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white24, thickness: 1),

            // ⚙️ Profile Options
            _buildLanguageOption(),
            TranslationBuilder(
              builder: (context) => _buildProfileOption(
                icon: Icons.lock,
                title: 'change_password'.tr,
                onTap: () {},
              ),
            ),
            TranslationBuilder(
              builder: (context) => _buildProfileOption(
                icon: Icons.notifications,
                title: 'notifications'.tr,
                onTap: () {},
              ),
            ),
            TranslationBuilder(
              builder: (context) => _buildProfileOption(
                icon: FontAwesomeIcons.cow,
                title: 'my_bail_ox'.tr,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyBailOxPage()),
                  );
                },
              ),
            ),
            // Show Host option only for predefined host email
            if (isHost)
              TranslationBuilder(
                builder: (context) => _buildProfileOption(
                  icon: FontAwesomeIcons.crown,
                  title: 'host'.tr,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardPage(userKey: widget.userKey,)),
                    );
                  },
                ),
              ),
            TranslationBuilder(
              builder: (context) => _buildProfileOption(
                icon: Icons.privacy_tip,
                title: 'privacy'.tr,
                onTap: () {},
              ),
            ),
            TranslationBuilder(
              builder: (context) => _buildProfileOption(
                icon: Icons.help,
                title: 'help'.tr,
                onTap: () {},
              ),
            ),
            TranslationBuilder(
              builder: (context) => _buildProfileOption(
                icon: Icons.info,
                title: 'about'.tr,
                onTap: () {},
              ),
            ),

            const SizedBox(height: 30),

            // 🚪 Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                ),
                onPressed: _showLogoutDialog, // ✅ Show popup
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const LiveTranslatedText(
                  'logout',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      ),
    );
  }

  // Language Option with Modern Selector
  Widget _buildLanguageOption() {
    return TranslationBuilder(
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          tileColor: Colors.black54,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: const Icon(Icons.language, color: Colors.orange, size: 28),
          title: LiveTranslatedText(
            'language',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: const ModernLanguageSelector(showAsBottomSheet: true),
        ),
      ),
    );
  }

  // Reusable Profile Option Tile
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        tileColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: Colors.orange, size: 28),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
        onTap: onTap,
      ),
    );
  }
}
