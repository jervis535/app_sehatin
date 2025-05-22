import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/message_model.dart';

class MessageService {
  static String get _baseUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_BASE_URL not set in .env');
    }
    return url;
  }

  static Future<List<MessageModel>> getMessages(int channelId) async {
    final uri = Uri.parse('$_baseUrl/messages?channel_id=$channelId');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<void> sendMessage(int channelId, int userId, String content) async {
    final uri = Uri.parse('$_baseUrl/messages');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'channel_id': channelId,
        'user_id': userId,
        'content': content,
      }),
    );
    if (res.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}
