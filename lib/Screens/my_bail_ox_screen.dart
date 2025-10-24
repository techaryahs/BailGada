// lib/my_bail_ox_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/translation_helper.dart';

class MyBailOxPage extends StatefulWidget {
  const MyBailOxPage({super.key});

  @override
  State<MyBailOxPage> createState() => _MyBailOxPageState();
}

class _MyBailOxPageState extends State<MyBailOxPage> {
  // --- Default demo data (no external asset required) ---
  // image: null means show placeholder icon; added types for clarity
  final List<Map<String, String?>> oxList = [
    {"name": "Ganesh", "image": null, "type": "Single", "bail_type": "Adat bail"},
    {"name": "Bheem & Bala", "image": null, "type": "Pair", "bail_type": "Dusa bail"},
    {"name": "Raja", "image": null, "type": "Single", "bail_type": "Chosa bail"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: TranslationBuilder(
          builder: (context) => Text(
            'my_bail_ox'.tr,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: oxList.isEmpty ? _emptyState() : _oxListView(),
      floatingActionButton: _buildAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _emptyState() {
    return TranslationBuilder(
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pets, color: Colors.white38, size: 64),
            const SizedBox(height: 12),
            Text('no_ox_added_yet'.tr, style: const TextStyle(color: Colors.white70)),
          ],
        ),
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
            color: Colors.black.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.deepOrangeAccent.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrangeAccent.withValues(alpha: 0.12),
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
                      TranslationBuilder(
                        builder: (context) => Text(
                          ox["name"] ?? 'unnamed_ox'.tr,
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      if (ox["bail_type"] != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.category, size: 14, color: Colors.orangeAccent),
                            const SizedBox(width: 6),
                            Text(
                              ox["bail_type"]!,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
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
              ? [Colors.deepOrangeAccent.withValues(alpha: 0.2), Colors.orange.withValues(alpha: 0.15)]
              : [Colors.orange.withValues(alpha: 0.12), Colors.deepOrangeAccent.withValues(alpha: 0.08)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.25)),
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
              "bail_type": newOx["bail_type"],
              "bail_details": newOx["bail_details"],
              "bail_achievements": newOx["bail_achievements"],
            });
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF6E40), Color(0xFFFF3D00)]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.deepOrangeAccent.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: TranslationBuilder(
                builder: (context) => Text(
                  'add_ox'.tr, 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
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
  final TextEditingController _bailDetailsCtrl = TextEditingController();
  final TextEditingController _bailAchievementsCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String _selectedType = "Single";
  String _selectedBailType = "Adat bail";
  File? _ox1Image;
  File? _ox2Image;

  @override
  void dispose() {
    _ox1NameCtrl.dispose();
    _ox2NameCtrl.dispose();
    _bailDetailsCtrl.dispose();
    _bailAchievementsCtrl.dispose();
    super.dispose();
  }

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
      _showSnack('please_add_ox_photo'.tr);
      return;
    }

    if (_selectedType == "Pair" && (_ox1Image == null || _ox2Image == null)) {
      _showSnack('please_add_both_ox_photos'.tr);
      return;
    }

    final result = {
      "type": _selectedType,
      "bail_type": _selectedBailType,
      "ox1_name": _ox1NameCtrl.text.trim(),
      "ox1_image": _ox1Image?.path,
      "ox2_name": _selectedType == "Pair" ? _ox2NameCtrl.text.trim() : null,
      "ox2_image": _selectedType == "Pair" ? _ox2Image?.path : null,
      "bail_details": _bailDetailsCtrl.text.trim().isNotEmpty ? _bailDetailsCtrl.text.trim() : null,
      "bail_achievements": _bailAchievementsCtrl.text.trim().isNotEmpty ? _bailAchievementsCtrl.text.trim() : null,
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
        title: TranslationBuilder(
          builder: (context) => Text(
            'add_ox'.tr,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🔸 Type Dropdown (Single/Pair)
              TranslationBuilder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'select_type'.tr,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      dropdownColor: Colors.black,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.5)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "Single",
                          child: Text('single'.tr, style: const TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: "Pair",
                          child: Text('pair'.tr, style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                      onChanged: (v) => setState(() => _selectedType = v ?? "Single"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔸 Bail Type Dropdown
              TranslationBuilder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'bail_type'.tr,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedBailType,
                      dropdownColor: Colors.black,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.5)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "Adat bail",
                          child: Text('adat_bail'.tr, style: const TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: "Dusa bail",
                          child: Text('dusa_bail'.tr, style: const TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: "Chosa bail",
                          child: Text('chosa_bail'.tr, style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                      onChanged: (v) => setState(() => _selectedBailType = v ?? "Adat bail"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🐂 Fields for Single OX
              if (_selectedType == "Single")
                _buildSingleOxSection(),

              // 🐂 Fields for Pair OX
              if (_selectedType == "Pair")
                _buildPairOxSection(),

              const SizedBox(height: 20),

              // 📝 Bail Details (Optional)
              TranslationBuilder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'bail_details'.tr,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bailDetailsCtrl,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'bail_details_hint'.tr,
                        hintStyle: const TextStyle(color: Colors.white30),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.5)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🏆 Bail Achievements (Optional)
              TranslationBuilder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'bail_achievements'.tr,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bailAchievementsCtrl,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'bail_achievements_hint'.tr,
                        hintStyle: const TextStyle(color: Colors.white30),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.5)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ✅ Save Button
              TranslationBuilder(
                builder: (context) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _submit,
                  child: Text(
                    'save_ox'.tr,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleOxSection() {
    return TranslationBuilder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ox_details'.tr,
            style: const TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ox1NameCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'ox_name'.tr,
              labelStyle: const TextStyle(color: Colors.orangeAccent),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.5)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent),
              ),
              hintText: "e.g. Ganesh",
              hintStyle: const TextStyle(color: Colors.white30),
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'enter_ox_name'.tr : null,
          ),
          const SizedBox(height: 16),
          _imagePickerTile('ox_photo'.tr, _ox1Image, () => _pickImage(true)),
        ],
      ),
    );
  }

  Widget _buildPairOxSection() {
    return TranslationBuilder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ox_pair_details'.tr,
            style: const TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ox1NameCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'first_ox_name'.tr,
              labelStyle: const TextStyle(color: Colors.orangeAccent),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.5)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent),
              ),
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'enter_first_ox_name'.tr : null,
          ),
          const SizedBox(height: 16),
          _imagePickerTile('first_ox_photo'.tr, _ox1Image, () => _pickImage(true)),

          const SizedBox(height: 24),

          TextFormField(
            controller: _ox2NameCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'second_ox_name'.tr,
              labelStyle: const TextStyle(color: Colors.orangeAccent),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.5)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent),
              ),
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'enter_second_ox_name'.tr : null,
          ),
          const SizedBox(height: 16),
          _imagePickerTile('second_ox_photo'.tr, _ox2Image, () => _pickImage(false)),
        ],
      ),
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
          border: Border.all(color: Colors.deepOrangeAccent.withValues(alpha: 0.6)),
        ),
        child: imageFile == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, color: Colors.orangeAccent, size: 40),
            const SizedBox(height: 10),
            TranslationBuilder(
              builder: (context) => Text(
                "${'tap_to_add'.tr} $label",
                style: const TextStyle(color: Colors.white70),
              ),
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
