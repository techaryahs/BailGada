import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../host/Screens/dashboard_page.dart';

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

    final prefs = await SharedPreferences.getInstance();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Confirm Logout",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to log out?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child:
              const Text("Cancel", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await prefs.setBool("isLoggedIn", false);
                await prefs.setString("userKey", "");
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacementNamed(context, "/signin");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
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
            _buildProfileOption(
              icon: Icons.lock,
              title: "Change Password",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.notifications,
              title: "Notifications",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: FontAwesomeIcons.cow,
              title: "Bail (OX)",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: FontAwesomeIcons.crown,
              title: "Host",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardPage()),
                );
              },
            ),
            _buildProfileOption(
              icon: Icons.privacy_tip,
              title: "Privacy Policy",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.help,
              title: "Help & Support",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.info,
              title: "About App",
              onTap: () {},
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
                label: const Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
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
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      tileColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: Colors.orange, size: 28),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing:
      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
      onTap: onTap,
    );
  }
}
