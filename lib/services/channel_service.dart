import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/channel_model.dart';

class ChannelService {
  static String get _baseUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception(
        'API_BASE_URL not found; did you call dotenv.load()?'
      );
    }
    return url;
  }

  /// Create a 1:1 channel between two user IDs
  static Future<int?> createChannel(int user0, int user1) async {
    final uri = Uri.parse('$_baseUrl/channels');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id0': user0, 'user_id1': user1}),
    );
    if (res.statusCode == 201) {
      return (jsonDecode(res.body) as Map<String, dynamic>)['id'] as int;
    }
    return null;
  }

  /// Fetch all channels involving [userId]
  static Future<List<ChannelModel>> getUserChannels(int userId) async {
    final uri = Uri.parse('$_baseUrl/channels?user_id=$userId');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data
          .map((e) => ChannelModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load channels: ${res.statusCode}');
  }
}
