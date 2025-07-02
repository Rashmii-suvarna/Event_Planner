import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/event_background.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "All Events",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('events')
                          .orderBy('date', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Error loading events",
                                  style: TextStyle(color: Colors.white)));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final events = snapshot.data!.docs;

                        if (events.isEmpty) {
                          return const Center(
                            child: Text(
                              "No events found.",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final doc = events[index];
                            final data = doc.data() as Map<String, dynamic>;

                            final name = data['name'] ?? 'Unnamed Event';
                            final description = data['description'] ?? '';
                            final location = data['location'] ?? 'Unknown';
                            final date = (data['date'] is Timestamp)
                                ? (data['date'] as Timestamp)
                                    .toDate()
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]
                                : 'N/A';
                            final attendees = data['rsvp'] != null
                                ? (data['rsvp'] as List).length
                                : 0;
                            final comments = data['comments'] != null
                                ? (data['comments'] as List).length
                                : 0;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text("Date: $date",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text("Location: $location",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text("Attendees: $attendees",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text("Comments: $comments",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ],
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EventDetailsScreen(
                                          eventId: doc.id),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
