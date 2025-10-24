import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animate_do/animate_do.dart';
import '../utils/translation_helper.dart';
import 'event_form_preview_page.dart';

class EventRegistrationForm extends StatefulWidget {
  final String eventName;
  final String userKey;

  const EventRegistrationForm({
    super.key,
    required this.eventName,
    required this.userKey,
  });

  @override
  State<EventRegistrationForm> createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ox1Controller = TextEditingController();
  final TextEditingController ox2Controller = TextEditingController();

  bool isPaymentDone = false;
  bool isSubmitting = false;

  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("events");

  // Generate unique 12-digit participant key
  String generateParticipantKey() {
    final random = Random();
    return List.generate(12, (_) => random.nextInt(10)).join();
  }

  // 💾 Submit Form
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("please_fill_all_fields".tr),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    setState(() => isSubmitting = true);

    // Simulate Payment Success
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isPaymentDone = true);

    final participantKey = generateParticipantKey();
    final formData = {
      "participantKey": participantKey,
      "userKey": widget.userKey,
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "ox1": ox1Controller.text.trim(),
      "ox2": ox2Controller.text.trim(),
      "paymentStatus": "Paid",
      "timestamp": DateTime.now().toIso8601String(),
    };

    // Store in Firebase
    await dbRef
        .child(widget.eventName)
        .child("participants")
        .child(participantKey)
        .set(formData);

    setState(() => isSubmitting = false);

    // 🎉 Show Success Dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FadeInDown(
        duration: const Duration(milliseconds: 400),
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "✅ ${"form_submitted_successfully".tr}",
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            "thank_you_for_registering".tr,
            style: const TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventFormPreviewPage(
                      formData: formData,
                      eventName: widget.eventName,
                      userKey: widget.userKey,
                    ),
                  ),
                );
              },
              child: Text(
                "view_preview".tr,
                style: const TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "event_registration".tr,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isSubmitting
          ? const Center(
          child: CircularProgressIndicator(color: Colors.orangeAccent))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "fill_participant_details".tr,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: nameController,
                  label: "full_name".tr,
                  icon: Icons.person,
                  validator: (v) =>
                  v == null || v.isEmpty ? "enter_name".tr : null,
                ),
                _buildTextField(
                  controller: phoneController,
                  label: "phone_number".tr,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                  v == null || v.isEmpty ? "enter_phone".tr : null,
                ),

                const SizedBox(height: 14),
                Text("ox_pair_details".tr,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                _buildTextField(
                  controller: ox1Controller,
                  label: "first_ox_name".tr,
                  icon: Icons.pets,
                  validator: (v) =>
                  v == null || v.isEmpty ? "enter_first_ox_name".tr : null,
                ),
                _buildTextField(
                  controller: ox2Controller,
                  label: "second_ox_name".tr,
                  icon: Icons.pets,
                  validator: (v) =>
                  v == null || v.isEmpty ? "enter_second_ox_name".tr : null,
                ),

                const SizedBox(height: 40),

                // Payment Section
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _submitForm,
                    icon: const Icon(Icons.payment, color: Colors.black),
                    label: Text(
                      "proceed_to_payment".tr,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
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
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          filled: true,
          fillColor: Colors.orange.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.6)),
          ),
        ),
      ),
    );
  }
}
