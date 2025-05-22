import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/medical_history.dart';
import '../services/medical_history_service.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final User user;

  const MedicalHistoryScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  late Future<List<MedicalHistory>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = MedicalHistoryService.getByUserId(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical History')),
      body: FutureBuilder<List<MedicalHistory>>(
        future: _futureHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No medical history found.'));
          }

          final history = snapshot.data!;
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Medications: ${entry.medications}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Conditions: ${entry.medicalConditions}'),
                      Text('Notes: ${entry.notes}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
