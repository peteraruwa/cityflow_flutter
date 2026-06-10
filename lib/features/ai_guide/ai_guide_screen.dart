import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';

const _quickQuestions = [
  'Find a restaurant',
  'Book a ride',
  'Emergency help',
  'Prayer times',
  'Events today',
];

const _mockResponses = {
  'restaurant':
      'There are several dining options in Redemption City:\n\n• Camp Restaurant (Block A) — Open 7AM–9PM\n• Food Court near Gate B — Various vendors\n• Cafeteria at the Youth Centre\n\nWould you like directions to any of these?',
  'ride':
      'I can help you book a CityRide! Available options:\n\n• Camp Shuttle (₦150) — 8 min wait\n• Standard (₦450) — 5 min wait\n• Premium (₦850) — 3 min wait\n\nTap CityRide in the bottom nav to book.',
  'emergency':
      'Emergency contacts for Redemption City:\n\n🚑 Ambulance: 199\n🚔 Police: 112\n🚒 Fire Service: 190\n🚗 Road Safety: 122\n\nFor life-threatening emergencies, call 112 immediately.',
  'prayer':
      'Regular prayer sessions at Redemption City:\n\n• Daily Prayer — 6:00 AM, Old Auditorium\n• Digging Deep — Tuesdays 6 PM, Faith Chapel\n• Faith Clinic — Thursdays 6 PM\n• Sunday Victory Service — 7:00 AM, New Arena',
  'default':
      "I'm CityFlow AI, your guide to Redemption City! I can help you with:\n\n• Directions and navigation\n• Booking CityRides\n• Finding churches and services\n• Emergency contacts\n• Events and programs\n\nWhat would you like to know?",
};

String _getResponse(String message) {
  final lower = message.toLowerCase();
  if (lower.contains('restaurant') ||
      lower.contains('food') ||
      lower.contains('eat') ||
      lower.contains('dining')) {
    return _mockResponses['restaurant']!;
  }
  if (lower.contains('ride') || lower.contains('transport') || lower.contains('car')) {
    return _mockResponses['ride']!;
  }
  if (lower.contains('emergency') ||
      lower.contains('help') ||
      lower.contains('ambulance') ||
      lower.contains('police')) {
    return _mockResponses['emergency']!;
  }
  if (lower.contains('prayer') || lower.contains('pray') || lower.contains('worship')) {
    return _mockResponses['prayer']!;
  }
  return _mockResponses['default']!;
}

class AiGuideScreen extends StatefulWidget {
  const AiGuideScreen({super.key});

  @override
  State<AiGuideScreen> createState() => _AiGuideScreenState();
}

class _AiGuideScreenState extends State<AiGuideScreen>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Message> _messages = [];
  bool _isTyping = false;
  late final AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    // Initial AI greeting
    _messages.add(
      const _Message(
        role: 'assistant',
        content:
            "Hello! I'm CityFlow AI. How can I help you navigate Redemption City today? 👋",
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();

    setState(() {
      _messages.add(_Message(role: 'user', content: text));
      _isTyping = true;
    });
    _scrollToBottom();

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add(_Message(role: 'assistant', content: _getResponse(text)));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: kBorder)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: kCream),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: kPurple.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy_outlined,
                        color: kPurpleLight, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CityFlow AI',
                          style: TextStyle(
                            color: kCream,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: kSuccess,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Online',
                              style:
                                  TextStyle(color: kSuccess, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return _TypingIndicator(controller: _dotController);
                  }
                  return _MessageBubble(message: _messages[index]);
                },
              ),
            ),
            // Quick questions (show when ≤1 message sent by user)
            if (_messages.where((m) => m.role == 'user').length < 1)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: _quickQuestions
                      .map(
                        (q) => GestureDetector(
                          onTap: () => _sendMessage(q),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: kSurface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: kBorder),
                            ),
                            child: Text(
                              q,
                              style: const TextStyle(
                                color: kCream,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            // Input bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: kBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      enabled: !_isTyping,
                      minLines: 1,
                      maxLines: 4,
                      style: const TextStyle(color: kCream),
                      cursorColor: kPurple,
                      onSubmitted: (v) {
                        if (!_isTyping) _sendMessage(v);
                      },
                      decoration: InputDecoration(
                        hintText: 'Ask CityFlow…',
                        hintStyle: const TextStyle(color: kMutedText),
                        filled: true,
                        fillColor: kSurface,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: kPurpleLight, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, _) {
                      final hasText = _textController.text.isNotEmpty;
                      return IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor:
                              hasText && !_isTyping ? kPurple : kDimText,
                        ),
                        onPressed: _isTyping || !hasText
                            ? null
                            : () => _sendMessage(_textController.text),
                        icon: const Icon(Icons.send, color: kCream),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message {
  const _Message({required this.role, required this.content});
  final String role;
  final String content;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _Message message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(colors: [kPurple, kPurpleDark])
              : null,
          color: isUser ? null : kSurface,
          borderRadius: BorderRadius.circular(14),
          border: isUser
              ? null
              : Border.all(color: kPurple.withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isUser) ...[
              const Icon(Icons.smart_toy_outlined,
                  color: kPurpleLight, size: 16),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message.content,
                style: const TextStyle(
                  color: kCream,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kPurple.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final offset = (controller.value - i * 0.2).clamp(0.0, 1.0);
                final y = -4.0 *
                    (1 - (2 * offset - 1).abs()).clamp(0.0, 1.0);
                return Transform.translate(
                  offset: Offset(0, y),
                  child: Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: const BoxDecoration(
                      color: kPurpleLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
