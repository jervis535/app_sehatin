import 'package:flutter/material.dart';
import '../models/user.dart';
import '../../models/doctor_model.dart';
import '../../services/doctor_service.dart';
import '../../services/channel_service.dart';
import 'chat_screen.dart';

class ConsultationScreen extends StatefulWidget {
  final User user;
  const ConsultationScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  List<String> _specializations = [];
  String? _selectedSpec;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSpecializations();
  }

  Future<void> _loadSpecializations() async {
    try {
      final doctors = await DoctorService.getAllDoctors();
      final specs = doctors.map((d) => d.specialization).toSet().toList();
      setState(() {
        _specializations = specs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load specializations';
        _loading = false;
      });
    }
  }

  Future<void> _findAndChat() async {
    print(1);
    if (_selectedSpec == null) return;
    print(2);
    setState(() => _loading = true);
    print(3);

    try {
      final doctors = await DoctorService.getBySpecialization(_selectedSpec!);
      // // Check if the list of doctors is empty
      // if (doctors!=null) {
      // print(5); // Debugging statement
      // setState(() {
      //   _error = 'No doctor found for "$_selectedSpec"';
      //   _loading = false;
      // });
      // return;
      final doctor = doctors.first;
      final channelId = await ChannelService.createChannel(
        widget.user.id,
        doctor.userId,
      );
      if (channelId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(channelId: channelId, user: widget.user),
            // builder: (_) => ChatScreen(channelId: channelId),
          ),
        );
      } else {
        setState(() {
          _error = 'Failed to create channel';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Consultation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            DropdownButtonFormField<String>(
              value: _selectedSpec,
              items: _specializations
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedSpec = v),
              decoration:
                  const InputDecoration(labelText: 'Specialization'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _findAndChat,
              child: const Text('Find Doctor & Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
