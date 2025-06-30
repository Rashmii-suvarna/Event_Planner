import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> addComment() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty || user == null) return;

    final nameOrEmail = user!.displayName ?? user!.email;

    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .update({
      'comments': FieldValue.arrayUnion(['$nameOrEmail: $comment']),
    });

    _commentController.clear();
  }

  Future<void> rsvpToEvent() async {
    final nameOrEmail = user?.displayName ?? user?.email;
    if (nameOrEmail == null) return;

    final docRef =
        FirebaseFirestore.instance.collection('events').doc(widget.eventId);
    final doc = await docRef.get();
    final data = doc.data() as Map<String, dynamic>;

    final currentRSVP = List<String>.from(data['rsvp'] ?? []);

    if (!currentRSVP.contains(nameOrEmail)) {
      await docRef.update({
        'rsvp': FieldValue.arrayUnion([nameOrEmail]),
      });
    }
  }

  Future<void> deleteComment(String comment) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .update({
      'comments': FieldValue.arrayRemove([comment]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/event_background.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .doc(widget.eventId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              DateTime? date;
              if (data['date'] is Timestamp) {
                date = (data['date'] as Timestamp).toDate();
              }
              final formattedDate = date != null
                  ? DateFormat.yMMMd().add_jm().format(date)
                  : 'N/A';

              final comments = List<String>.from(data['comments'] ?? []);
              final rsvps = List<String>.from(data['rsvp'] ?? []);

              final userIdentifier =
                  user?.displayName ?? user?.email ?? '';

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? 'Event',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['description'] ?? '',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Location: ${data['location'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Date: $formattedDate',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Attending: ${rsvps.length}',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: rsvpToEvent,
                          child: const Text("Attending this function"),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'People attending:',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        ...rsvps.map(
                          (attendee) => Text(
                            '- $attendee',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Comments:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ...comments.map((c) {
                          final parts = c.split(':');
                          final author = parts.first.trim();

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  '- $c',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                              if (author == userIdentifier)
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                  onPressed: () => deleteComment(c),
                                ),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _commentController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: addComment,
                          child: const Text("Submit Comment"),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Back to Events"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
