import 'package:flutter/material.dart';
import '../../utils/marathi_utils.dart';
import '../../utils/translation_helper.dart';

class Addeventscreen extends StatefulWidget {
  const Addeventscreen({super.key});

  @override
  State<Addeventscreen> createState() => _AddeventscreenState();
}

class _AddeventscreenState extends State<Addeventscreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventIntroController = TextEditingController();
  final TextEditingController _eventVideoController = TextEditingController();
  final TextEditingController _eventLocationController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _tracksController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();

  DateTime? _selectedDateTime;

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("add_event".tr),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1B0B00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) => const LinearGradient(
                      colors: [Colors.deepOrangeAccent, Colors.orangeAccent],
                    ).createShader(bounds),
                    child: const Text(
                      "Event Details",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField("Event Name", _eventNameController),
                      _buildTextField("Event Intro (Optional)", _eventIntroController),
                      _buildTextField("Event Intro Video (Optional)", _eventVideoController),
                      _uploadButton("Upload Event Banner"),
                      _buildTextField("Event Location", _eventLocationController),
                      _dateTimePicker(),
                      _buildTextField("Total Number of Participants", _participantsController,
                          keyboard: TextInputType.number),
                      _buildTextField("Number of Tracks", _tracksController,
                          keyboard: TextInputType.number),
                      _uploadButton("Upload Approval Certificate"),
                      _buildTextField("Register Fees For Participation", _feesController,
                          keyboard: TextInputType.number),
                      const SizedBox(height: 30),

                      // Submit Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text("✅ Event Submitted Successfully")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 16),
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 10,
                            shadowColor: Colors.orangeAccent.withValues(alpha: 0.6),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }

  // Text Fields
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.orangeAccent,
            fontSize: 15,
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.w600,
            backgroundColor: Colors.black,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.3),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orangeAccent),
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orangeAccent),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: Colors.deepOrangeAccent, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  // Upload Buttons
  Widget _uploadButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.orangeAccent),
            gradient: LinearGradient(
              colors: [Colors.orange.withValues(alpha: 0.2), Colors.black.withValues(alpha: 0.4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.upload_rounded, color: Colors.orangeAccent),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(color: Colors.orangeAccent, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DateTime Picker
  Widget _dateTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: _pickDateTime,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            border: Border.all(color: Colors.orangeAccent),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.orangeAccent),
              const SizedBox(width: 10),
              Text(
                _selectedDateTime == null
                    ? "select_date".tr
                    : '${MarathiUtils.formatDate(_selectedDateTime!.toIso8601String())}, ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
