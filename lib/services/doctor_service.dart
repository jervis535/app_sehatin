import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/doctor_model.dart';

class DoctorService {
  static final _baseUrl = dotenv.env['API_URL']!;

  /// Fetch all doctors
  static Future<List<DoctorModel>> getAllDoctors() async {
    final res = await http.get(Uri.parse('$_baseUrl/doctors'));
    final List data = jsonDecode(res.body);
    return data.map((e) => DoctorModel.fromJson(e)).toList();
  }

  static Future<List<DoctorModel>> getBySpecialization(String spec) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/doctors?specialization=$spec'),
    );

    final List data = jsonDecode(res.body);
    return data.map((doctorJson) => DoctorModel.fromJson(doctorJson)).toList();
  }
}
