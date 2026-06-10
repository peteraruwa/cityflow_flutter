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
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return _fallback;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$kGeminiEndpoint/models/$kGeminiModel:generateContent',
        queryParameters: {'key': apiKey},
        options: Options(
          headers: {
            'content-type': 'application/json',
          },
        ),
        data: {
          'systemInstruction': {
            'parts': [
              {'text': _systemPrompt},
            ],
          },
          'contents': messages.skip(1).map(_toGeminiContent).toList(),
          'generationConfig': {
            'maxOutputTokens': 1000,
            'temperature': 0.6,
          },
        },
      );

      final data = response.data;
      final candidates = data?['candidates'];
      if (candidates is List && candidates.isNotEmpty) {
        final first = candidates.first;
        if (first is Map<String, dynamic>) {
          final content = first['content'];
          if (content is Map<String, dynamic>) {
            final parts = content['parts'];
            if (parts is List && parts.isNotEmpty) {
              final firstPart = parts.first;
              if (firstPart is Map && firstPart['text'] is String) {
                return firstPart['text'] as String;
              }
            }
          }
        }
      }

      return _fallback;
    } catch (_) {
      return _fallback;
    }
  }

  Map<String, dynamic> _toGeminiContent(Map<String, String> message) {
    final role = message['role'] == 'assistant' ? 'model' : 'user';
    return {
      'role': role,
      'parts': [
        {'text': message['content'] ?? ''},
      ],
    };
  }
}
