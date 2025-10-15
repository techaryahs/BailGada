// lib/my_bail_ox_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyBailOxPage extends StatefulWidget {
  const MyBailOxPage({super.key});

  @override
  State<MyBailOxPage> createState() => _MyBailOxPageState();
}

class _MyBailOxPageState extends State<MyBailOxPage> {
  // --- Default demo data (no external asset required) ---
  // image: null means show placeholder icon; added types for clarity
  final List<Map<String, String?>> oxList = [
    {"name": "Ganesh", "image": null, "type": "Single"},
    {"name": "Bheem & Bala", "image": null, "type": "Pair"},
    {"name": "Raja", "image": null, "type": "Single"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: const Text(
          "My Bail (OX)",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: oxList.isEmpty ? _emptyState() : _oxListView(),
      floatingActionButton: _buildAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.pets, color: Colors.white38, size: 64),
          SizedBox(height: 12),
          Text("No OX added yet", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _oxListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: oxList.length,
      itemBuilder: (context, index) {
        final ox = oxList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.deepOrangeAccent.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrangeAccent.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // image or placeholder
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
                child: SizedBox(
                  width: 110,
                  height: 110,
                  child: _buildOxImage(ox["image"]),
                ),
              ),

              // info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ox["name"] ?? "Unnamed OX",
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _typeChip(ox["type"] ?? "Single"),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "ID: ${1000 + index}", // placeholder id
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOxImage(String? path) {
    // If path provided and points to a file that exists -> show file
    if (path != null && path.isNotEmpty) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          return Image.file(file, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
        }
      } catch (_) {
        // ignore and fallback to other checks
      }

      // network image fallback
      if (path.startsWith('http')) {
        return Image.network(path, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
      }
    }

    // Default placeholder
    return Container(
      color: Colors.grey.shade900,
      child: const Center(
        child: Icon(Icons.pets, color: Colors.white54, size: 46),
      ),
    );
  }

  Widget _typeChip(String type) {
    final isPair = type.toLowerCase() == "pair";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPair
              ? [Colors.deepOrangeAccent.withOpacity(0.2), Colors.orange.withOpacity(0.15)]
              : [Colors.orange.withOpacity(0.12), Colors.deepOrangeAccent.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isPair ? Icons.group : Icons.person, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(type, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () async {
        final newOx = await Navigator.push<Map<String, String>?>(
          context,
          MaterialPageRoute(builder: (_) => const AddOxFormPage()),
        );

        if (newOx != null) {
          setState(() {
            // ensure keys exist as strings
            oxList.add({
              "name": newOx["name"],
              "image": newOx["image"],
              "type": newOx["type"] ?? "Single",
            });
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF6E40), Color(0xFFFF3D00)]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.deepOrangeAccent.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text("Add OX", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// -------------------------
/// Add OX Form Page
/// -------------------------
class AddOxFormPage extends StatefulWidget {
  const AddOxFormPage({super.key});

  @override
  State<AddOxFormPage> createState() => _AddOxFormPageState();
}

class _AddOxFormPageState extends State<AddOxFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ox1NameCtrl = TextEditingController();
  final TextEditingController _ox2NameCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String _selectedType = "Single";
  File? _ox1Image;
  File? _ox2Image;

  Future<void> _pickImage(bool isFirst) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        if (isFirst) {
          _ox1Image = File(picked.path);
        } else {
          _ox2Image = File(picked.path);
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedType == "Single" && _ox1Image == null) {
      _showSnack("Please add OX photo");
      return;
    }

    if (_selectedType == "Pair" && (_ox1Image == null || _ox2Image == null)) {
      _showSnack("Please add both OX photos");
      return;
    }

    final result = {
      "type": _selectedType,
      "ox1_name": _ox1NameCtrl.text.trim(),
      "ox1_image": _ox1Image?.path,
      "ox2_name": _selectedType == "Pair" ? _ox2NameCtrl.text.trim() : null,
      "ox2_image": _selectedType == "Pair" ? _ox2Image?.path : null,
    };

    Navigator.pop(context, result);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepOrangeAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text(
          "Add OX",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🔸 Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedType,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
                items: const [
                  DropdownMenuItem(value: "Single", child: Text("Single", style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: "Pair", child: Text("Pair", style: TextStyle(color: Colors.white))),
                ],
                onChanged: (v) => setState(() => _selectedType = v ?? "Single"),
                decoration: InputDecoration(
                  labelText: "Select Type",
                  labelStyle: const TextStyle(color: Colors.orangeAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent.withOpacity(0.5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🐂 Fields for Single OX
              if (_selectedType == "Single")
                _buildSingleOxSection(),

              // 🐂 Fields for Pair OX
              if (_selectedType == "Pair")
                _buildPairOxSection(),

              const SizedBox(height: 30),

              // ✅ Save Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submit,
                child: const Text(
                  "Save OX",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleOxSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "OX Details",
          style: TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _ox1NameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "OX Name",
            labelStyle: const TextStyle(color: Colors.orangeAccent),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent.withOpacity(0.5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
            hintText: "e.g. Ganesh",
            hintStyle: const TextStyle(color: Colors.white30),
          ),
          validator: (v) => v == null || v.trim().isEmpty ? "Enter OX name" : null,
        ),
        const SizedBox(height: 16),
        _imagePickerTile("OX Photo", _ox1Image, () => _pickImage(true)),
      ],
    );
  }

  Widget _buildPairOxSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "OX Pair Details",
          style: TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _ox1NameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "First OX Name",
            labelStyle: const TextStyle(color: Colors.orangeAccent),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent.withOpacity(0.5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
          ),
          validator: (v) => v == null || v.trim().isEmpty ? "Enter first OX name" : null,
        ),
        const SizedBox(height: 16),
        _imagePickerTile("First OX Photo", _ox1Image, () => _pickImage(true)),

        const SizedBox(height: 24),

        TextFormField(
          controller: _ox2NameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Second OX Name",
            labelStyle: const TextStyle(color: Colors.orangeAccent),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent.withOpacity(0.5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
          ),
          validator: (v) => v == null || v.trim().isEmpty ? "Enter second OX name" : null,
        ),
        const SizedBox(height: 16),
        _imagePickerTile("Second OX Photo", _ox2Image, () => _pickImage(false)),
      ],
    );
  }

  Widget _imagePickerTile(String label, File? imageFile, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepOrangeAccent.withOpacity(0.6)),
        ),
        child: imageFile == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, color: Colors.orangeAccent, size: 40),
            const SizedBox(height: 10),
            Text(
              "Tap to add $label",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
