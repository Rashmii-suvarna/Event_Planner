import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'create_event_screen.dart';
import 'event_list_screen.dart';
import 'event_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDEEHEYik592w7cJSr5iepq--rEfEbY-5M",
      authDomain: "event-planner-firebase.firebaseapp.com",
      projectId: "event-planner-firebase",
      storageBucket: "event-planner-firebase.appspot.com",
      messagingSenderId: "183353839656",
      appId: "1:183353839656:web:75d4cb04c1132a208ba51d",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/add': (context) => const CreateEventScreen(),
        '/view': (context) => const EventListScreen(),
        

        // Note: EventDetailsScreen is opened with MaterialPageRoute when tapped, not named route.
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          if (user.emailVerified) {
            return const HomeScreen();
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Please verify your email 📧"),
                    ElevatedButton(
                      onPressed: () async {
                        await user.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Verification email sent again.")),
                        );
                      },
                      child: const Text("Resend Email"),
                    ),
                    TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const Text("Back to Login"),
                    )
                  ],
                ),
              ),
            );
          }
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
