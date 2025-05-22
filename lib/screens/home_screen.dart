// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import 'consultation_screen.dart';
import 'channels_screen.dart';
import 'placeholders/service_screen.dart';
import 'medical_history.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final role = user.role.toLowerCase();
    return Scaffold(
      appBar: AppBar(title: Text('Welcome, ${user.email}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (role == 'user') ...[
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConsultationScreen(user: user),
                  ),
                ),
                child: const Text('Consultation'),
              ),
              const SizedBox(height: 8),
            ],
            // Chat is available to all roles
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChannelsScreen(user: user),
                ),
              ),
              child: const Text('My Channels'),
            ),
            const SizedBox(height: 8),
            if (role == 'user' || role == 'doctor') ...[
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicalHistoryScreen(user: user)),
                ),
                child: const Text('View Medical History'),
              ),
              const SizedBox(height: 8),
            ],
            if (role == 'user') ...[
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServiceScreen()),
                ),
                child: const Text('Service'),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
