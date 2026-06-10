import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ai_guide_service.dart';

final aiGuideControllerProvider =
    StateNotifierProvider<AiGuideController, AiGuideState>((ref) {
  return AiGuideController(ref.read(aiGuideServiceProvider));
});

class AiGuideState {
  const AiGuideState({
    required this.messages,
    this.isLoading = false,
  });

  final List<Map<String, String>> messages;
  final bool isLoading;

  AiGuideState copyWith({
    List<Map<String, String>>? messages,
    bool? isLoading,
  }) {
    return AiGuideState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AiGuideController extends StateNotifier<AiGuideState> {
  AiGuideController(this._service)
      : super(
          const AiGuideState(
            messages: [
              {
                'role': 'assistant',
                'content':
                    "Hi! I'm your CityFlow Assistant. Ask me about Redemption City.",
              },
            ],
          ),
        );

  final AiGuideService _service;

  Future<void> sendMessage(String text) async {
    final message = text.trim();
    if (message.isEmpty || state.isLoading) return;

    final nextMessages = [
      ...state.messages,
      {'role': 'user', 'content': message},
    ];
    state = state.copyWith(messages: nextMessages, isLoading: true);

    final response = await _service.sendMessage(nextMessages);

    state = state.copyWith(
      messages: [
        ...nextMessages,
        {'role': 'assistant', 'content': response},
      ],
      isLoading: false,
    );
  }
}
