import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final displayName = user.displayName;
      if (displayName != null && displayName.isNotEmpty) {
        setState(() => userName = displayName);
      } else {
        final email = user.email ?? "User";
        setState(() {
          userName = email.split('@')[0].replaceAll('.', ' ').replaceAll('_', ' ');
        });
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

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
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Updated Title – Stylish, No Background
                    const Text(
                      'Vibhoram',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 3,
                        fontFamily: 'Georgia', // You can change to a custom font if needed
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      '"Events create memories, memories create life."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Welcome, $userName!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add');
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text("Add Event"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 246, 251, 154),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/view');
                      },
                      icon: const Icon(Icons.view_list),
                      label: const Text("View Events"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 138, 236, 195),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 242, 168, 168),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
}
