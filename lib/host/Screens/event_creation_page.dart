import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({Key? key}) : super(key: key);

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> sponsors = [];

  String? eventName;
  String? eventIntro;
  String? eventVideoUrl;
  String? eventLocation;
  DateTime? eventDate;
  TimeOfDay? eventTime;
  int? totalParticipants;
  int? numberOfTracks;
  double? registrationFees;

  File? _bannerImage;
  File? _eventVideoFile;
  File? _approvalCertificate;
  final TextEditingController _videoUrlController = TextEditingController();
  String? _videoType;

  @override
  void dispose() {
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickBannerImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _bannerImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickEventVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _eventVideoFile = File(result.files.single.path!);
        _videoType = 'file';
        _videoUrlController.clear();
      });
    }
  }

  void _setVideoUrl(String url) {
    setState(() {
      eventVideoUrl = url;
      _videoType = 'url';
      _eventVideoFile = null;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final dbRef = FirebaseDatabase.instance.ref().child('events').push();
        String hostKey = dbRef.key!;

        await dbRef.set({
          'hostKey': hostKey,
          'eventName': eventName,
          'eventIntro': eventIntro,
          'eventVideoUrl': _videoType == 'url' ? _videoUrlController.text : null,
          'eventVideoPath': _eventVideoFile?.path,
          'eventBannerPath': _bannerImage?.path,
          'approvalCertificatePath': _approvalCertificate?.path, // ✅ Added
          'eventLocation': eventLocation,
          'eventDate': DateFormat('yyyy-MM-dd').format(eventDate!),
          'eventTime': eventTime?.format(context),
          'totalParticipants': totalParticipants,
          'numberOfTracks': numberOfTracks,
          'registrationFees': registrationFees,
          'sponsors': sponsors,
          'status': 'Pending',
          'createdAt': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Event successfully created!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to save event: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('🐂 Event Information'),
              _buildCard([
                _buildTextField(
                  label: 'Event Name *',
                  hint: 'Enter event name',
                  onSaved: (value) => eventName = value,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Event Intro (Optional)',
                  hint: 'Brief description of the event',
                  maxLines: 3,
                  onSaved: (value) => eventIntro = value,
                ),
                const SizedBox(height: 16),

                /// Upload video or YouTube URL
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickEventVideo,
                            icon: const Icon(Icons.video_library),
                            label: const Text('Upload Video'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF9800),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _videoUrlController,
                            decoration: const InputDecoration(
                              labelText: 'YouTube URL',
                              hintText: 'Paste YouTube link',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              if (val.isNotEmpty) _setVideoUrl(val);
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_eventVideoFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Video selected: ${_eventVideoFile!.path.split(Platform.pathSeparator).last}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    if (_videoType == 'url' && _videoUrlController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'YouTube URL: ${_videoUrlController.text}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Upload banner image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickBannerImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Upload Banner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF9800),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    if (_bannerImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.file(_bannerImage!, height: 120, fit: BoxFit.cover),
                      ),
                  ],
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader('📍 Location & Date'),
              _buildCard([
                _buildTextField(
                  label: 'Event Location *',
                  hint: 'Enter location',
                  onSaved: (value) => eventLocation = value,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  prefixIcon: Icons.location_on,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDatePicker()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTimePicker()),
                  ],
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader('🏁 Race Details'),
              _buildCard([
                _buildTextField(
                  label: 'Total Number of Participants *',
                  hint: 'Enter number',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => totalParticipants = int.tryParse(value ?? '0'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  prefixIcon: Icons.people,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Number of Tracks *',
                  hint: 'Enter number of tracks',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => numberOfTracks = int.tryParse(value ?? '0'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  prefixIcon: Icons.analytics,
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader('🧾 Documents & Fees'),
              _buildCard([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageUploadButton('Approval Certificate *', onFilePicked: (file) {
                      setState(() {
                        _approvalCertificate = file;
                      });
                    }),
                    if (_approvalCertificate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected: ${_approvalCertificate!.path.split(Platform.pathSeparator).last}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Registration Fees (₹) *',
                  hint: 'Enter amount',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => registrationFees = double.tryParse(value ?? '0'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  prefixIcon: Icons.currency_rupee,
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader('💼 Sponsors'),
              _buildCard([
                ...sponsors.asMap().entries.map((entry) {
                  return _buildSponsorCard(entry.key);
                }).toList(),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      sponsors.add({'name': '', 'intro': ''});
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Sponsor'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD87B3A),
                    side: const BorderSide(color: Color(0xFFD87B3A)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ]),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Draft Saved!')),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8B4513),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B8E23),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Submit for Approval'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8B4513),
      ),
    ),
  );

  Widget _buildCard(List<Widget> children) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ),
  );

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon:
        prefixIcon != null ? Icon(prefixIcon, color: const Color(0xFFD87B3A)) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD87B3A), width: 2),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildImageUploadButton(String label, {required Function(File) onFilePicked}) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(type: FileType.image);
            if (result != null && result.files.single.path != null) {
              final file = File(result.files.single.path!);
              onFilePicked(file);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload, size: 48, color: Color(0xFFD87B3A)),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to upload',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            eventDate = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Event Date *',
          prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFFD87B3A)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          eventDate != null
              ? '${eventDate!.day}/${eventDate!.month}/${eventDate!.year}'
              : 'Select date',
          style: TextStyle(color: eventDate != null ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (time != null) {
          setState(() {
            eventTime = time;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Event Time *',
          prefixIcon: const Icon(Icons.access_time, color: Color(0xFFD87B3A)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          eventTime != null ? eventTime!.format(context) : 'Select time',
          style: TextStyle(color: eventTime != null ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSponsorCard(int index) {
    return Card(
      color: const Color(0xFFFFF8DC),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sponsor ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      sponsors.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Sponsor Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                sponsors[index]['name'] = value;
              },
            ),
            const SizedBox(height: 12),
            _buildImageUploadButton('Sponsor Photo', onFilePicked: (file) {
              setState(() {
                sponsors[index]['photoPath'] = file.path;
              });
            }),
            if (sponsors[index]['photoPath'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Selected: ${sponsors[index]['photoPath'].split(Platform.pathSeparator).last}',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Sponsor Intro',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 3,
              onChanged: (value) {
                sponsors[index]['intro'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
