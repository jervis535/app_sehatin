import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/medical_history.dart';

class MedicalHistoryService {
  static final String baseUrl = dotenv.env['API_URL']!;

  static Future<List<MedicalHistory>> getByUserId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/medicalhistory?user_id=$userId'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => MedicalHistory.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load medical history');
    }
  }
}
