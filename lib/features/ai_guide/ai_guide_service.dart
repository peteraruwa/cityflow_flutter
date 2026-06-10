import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';

final aiGuideServiceProvider = Provider<AiGuideService>((ref) {
  return AiGuideService();
});

class AiGuideService {
  AiGuideService({Dio? dio}) : _dio = dio ?? Dio();

  static const _fallback =
      "Sorry, I couldn't reach the assistant. Please try again.";
  static const _systemPrompt =
      'You are CityFlow Assistant, a helpful guide for Redemption City '
      '(RCCG Camp), Ogun State, Nigeria. Help visitors navigate the city, '
      'find churches, events, businesses, and services within the camp. '
      'Keep responses concise and practical.';

  final Dio _dio;

  Future<String> sendMessage(List<Map<String, String>> messages) async {
    final apiKey = dotenv.env['ANTHROPIC_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return _fallback;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        kAnthropicEndpoint,
        options: Options(
          headers: {
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
        ),
        data: {
          'model': kAnthropicModel,
          'max_tokens': 1000,
          'system': _systemPrompt,
          'messages': messages,
        },
      );

      final data = response.data;
      final content = data?['content'];
      if (content is List && content.isNotEmpty) {
        final first = content.first;
        if (first is Map && first['text'] is String) {
          return first['text'] as String;
        }
      }

      return _fallback;
    } catch (_) {
      return _fallback;
    }
  }
}
