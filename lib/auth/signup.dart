import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../utils/translation_helper.dart';
import 'signin.dart';

class SignUp extends StatefulWidget {
  final String userKey;

  const SignUp({super.key, required this.userKey});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (!acceptTerms) {
      _showMessage("please_accept_terms".tr);
      return;
    }

    setState(() => isLoading = true);

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    var bytes = utf8.encode(password);
    var hashedPassword = sha256.convert(bytes).toString();

    try {
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("bailGada");
      final newUserRef = dbRef.child("users").push();
      String userKey = newUserRef.key!;
      await newUserRef.set({
        "key": userKey,
        "name": name,
        "email": email,
        "phone": phone,
        "password": hashedPassword,
        "role":"user",
        "created_at": DateTime.now().toIso8601String(),
      });

      if (mounted) {
        _showMessage("user_registered_successfully".tr);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn(userKey: widget.userKey,)),
        );
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
        content: Text(message),
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
                  const SizedBox(height: 20),
                  // Logo
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
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppColors.primary, AppColors.darkOrange],
                    ).createShader(bounds),
                    child: TranslationBuilder(
                      builder: (context) => Text(
                        "create_account".tr,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TranslationBuilder(
                    builder: (context) => Text(
                      "join_bailgada_race".tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
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
                          TranslationBuilder(
                            builder: (context) => _buildTextField(
                              controller: _nameController,
                              label: "full_name".tr,
                              icon: Icons.person_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please_enter_name'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          TranslationBuilder(
                            builder: (context) => _buildTextField(
                              controller: _emailController,
                              label: "email_address".tr,
                              icon: Icons.email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please_enter_email'.tr;
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'please_enter_valid_email'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          TranslationBuilder(
                            builder: (context) => _buildTextField(
                              controller: _phoneController,
                              label: "phone_number".tr,
                              icon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please_enter_phone'.tr;
                                }
                                if (value.length != 10) {
                                  return 'please_enter_valid_phone'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          TranslationBuilder(
                            builder: (context) => _buildTextField(
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
                          ),
                          const SizedBox(height: 16),
                          TranslationBuilder(
                            builder: (context) => _buildTextField(
                              controller: _confirmPasswordController,
                              label: "confirm_password".tr,
                              icon: Icons.lock_rounded,
                              obscure: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please_confirm_password'.tr;
                                }
                                if (value != _passwordController.text) {
                                  return 'passwords_dont_match'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: acceptTerms,
                                onChanged: (val) =>
                                    setState(() => acceptTerms = val ?? false),
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: TranslationBuilder(
                                  builder: (context) => Text(
                                    'agree_terms'.tr,
                                    style: TextStyle(
                                      color: AppColors.secondary.withValues(alpha: 0.7),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Sign Up Button
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
                              onPressed: isLoading ? null : _registerUser,
                              child: isLoading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                                  : TranslationBuilder(
                                builder: (context) => Text(
                                  "sign_up".tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sign In Link
                  TranslationBuilder(
                    builder: (context) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "${'already_have_account'.tr} ",
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
                            Navigator.pop(context);
                          },
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [AppColors.primary, AppColors.darkOrange],
                            ).createShader(bounds),
                            child: Text(
                              "sign_in".tr,
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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
