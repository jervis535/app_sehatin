import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../env/dotenv_config.dart';



class AuthService {
  final String _baseUrl = DotenvConfig.baseUrl;

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
    
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? specialization,
    String? poiId,
  }) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/users');
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'name': name,
      'role': role,
    };

    if (role == 'doctor' && specialization != null && poiId != null) {
      body['specialization'] = specialization;
      body['poi_id'] = int.tryParse(poiId);
    } else if (role == 'customer_service' && poiId != null) {
      body['poi_id'] = int.tryParse(poiId);
    }

    final res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));

    return jsonDecode(res.body);
  }
}
