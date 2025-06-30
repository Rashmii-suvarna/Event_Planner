import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController inviteesController = TextEditingController();

  DateTime? selectedDate;

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _addEvent() async {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      try {
        await FirebaseFirestore.instance.collection('events').add({
          'name': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'location': locationController.text.trim(),
          'date': Timestamp.fromDate(selectedDate!),
          'invitees': inviteesController.text.trim(),
          'attendees': 0,
          'comments': [],
          'rsvp': [],
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event added successfully!')),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add event.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields and pick a date.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/event_background.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Create Event',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildField(titleController, 'Event Title'),
                    _buildField(descriptionController, 'Description', maxLines: 3),
                    _buildField(locationController, 'Location'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        selectedDate == null
                            ? 'Pick Date'
                            : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade200,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addEvent,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        backgroundColor: const Color.fromARGB(255, 238, 248, 125),
                      ),
                      child: const Text('Add Event', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3), // ONLY for writing area
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
          ),
        ],
      ),
    );
  }
}
