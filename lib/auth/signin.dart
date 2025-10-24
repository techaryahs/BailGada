import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/home_screen.dart';
import '../utils/translation_helper.dart';
import '../host/Screens/dashboard_page.dart';
import 'signup.dart';

// Fresh Vibrant Orange and White theme colors
class AppColors {
  static const Color primary = Color(0xFFFF5722); // Vibrant Orange
  static const Color accent = Color(0xFFFF9800); // Bright Amber Orange
  static const Color background = Color(0xFFFFF3E0); // Light Cream/Peach
  static const Color secondary = Color(0xFF6D4C41); // Brown
  static const Color error = Color(0xFFE53935);
  static const Color darkOrange = Color(0xFFE64A19); // Deep Orange
}

class SignIn extends StatefulWidget {
  final String userKey;
  const SignIn({super.key, required this.userKey});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  bool rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Predefined host credentials
    const String hostEmail = 'Host@gmail.com';
    const String hostPassword = 'host_123';

    try {
      // Check if it's the host login first
      if (email.toLowerCase() == hostEmail.toLowerCase() && password == hostPassword) {
        // Create/update host entry in database
        final DatabaseReference dbRef = FirebaseDatabase.instance.ref("bailGada");
        final String hostKey = "host_admin";
        
        // Store host data in database
        await dbRef.child("users/$hostKey").set({
          "name": "Host Admin",
          "email": hostEmail,
          "phone": "N/A",
          "password": sha256.convert(utf8.encode(hostPassword)).toString(),
        });
        
        // Host login successful
        await prefs.setBool("isLoggedIn", true);
        await prefs.setString("userKey", hostKey);
        await prefs.setString("userEmail", email);
        await prefs.setBool("isHost", true);

        if (mounted) {
          // Navigate directly to Host Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardPage(userKey: widget.userKey,)),
          );
        }
        return;
      }

      // If not host, check regular users in database
      var bytes = utf8.encode(password);
      var hashedPassword = sha256.convert(bytes).toString();

      final DatabaseReference dbRef = FirebaseDatabase.instance.ref("bailGada");
      DatabaseEvent event = await dbRef.child("users").once();
      Map<dynamic, dynamic>? users = event.snapshot.value as Map?;

      if (users != null) {
        bool userFound = false;
        users.forEach((key, value) async {
          if (value["email"] == email && value["password"] == hashedPassword) {
            String userKey = key;
            userFound = true;
            await prefs.setBool("isLoggedIn", userFound);
            await prefs.setString("userKey", userKey);
            await prefs.setString("userEmail", email);
            await prefs.setBool("isHost", false);

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(userKey: userKey)),
              );
            }
          }
        });

        if (!userFound && mounted) {
          _showMessage("invalid_credentials".tr);
        }
      } else {
        _showMessage("no_data".tr);
      }

    } catch (e) {
      _showMessage("${'error'.tr}: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              AppColors.background,
              AppColors.accent.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo with gradient background
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sports_motorsports,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // App Title
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppColors.primary, AppColors.darkOrange],
                    ).createShader(bounds),
                    child: Text(
                      "bailgada_race".tr,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "sign_in_to_continue".tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _emailController,
                            label: "email_address".tr,
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'please_enter_email'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _passwordController,
                            label: "password".tr,
                            icon: Icons.lock_rounded,
                            obscure: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'please_enter_password'.tr;
                              }
                              if (value.length < 6) {
                                return 'password_min_6'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (val) =>
                                    setState(() => rememberMe = val ?? false),
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'remember_me'.tr,
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Sign In Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: isLoading ? null : _loginUser,
                              child: isLoading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                                  : Text(
                                "sign_in".tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "${'dont_have_account'.tr} ",
                          style: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.7),
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp(userKey:  widget.userKey,)),
                          );
                        },
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppColors.primary, AppColors.darkOrange],
                          ).createShader(bounds),
                          child: Text(
                            "sign_up".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: AppColors.secondary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background.withValues(alpha: 0.3),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 24),
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.secondary.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          backgroundColor: AppColors.background.withValues(alpha: 0.3),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.accent.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.accent.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
