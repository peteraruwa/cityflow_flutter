import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/colors.dart';
import '../../shared/widgets/loading_view.dart';
import 'ai_guide_controller.dart';

class AiGuideScreen extends ConsumerStatefulWidget {
  const AiGuideScreen({super.key});

  @override
  ConsumerState<AiGuideScreen> createState() => _AiGuideScreenState();
}

class _AiGuideScreenState extends ConsumerState<AiGuideScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiGuideControllerProvider);

    ref.listen<AiGuideState>(aiGuideControllerProvider, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    chatState.messages.length + (chatState.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == chatState.messages.length) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 42,
                        height: 42,
                        child: LoadingView(),
                      ),
                    );
                  }

                  return _MessageBubble(message: chatState.messages[index]);
                },
              ),
            ),
            _ChatInput(
              controller: _textController,
              isLoading: chatState.isLoading,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _textController.text;
    _textController.clear();
    await ref.read(aiGuideControllerProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final Map<String, String> message;

  @override
  Widget build(BuildContext context) {
    final isUser = message['role'] == 'user';
    final content = message['content'] ?? '';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? kPurple
              : Color.alphaBlend(
                  kPurple.withValues(alpha: 0.12),
                  kBackground,
                ),
          borderRadius: BorderRadius.circular(8),
          border: isUser
              ? null
              : Border.all(color: kPurple.withValues(alpha: 0.24)),
        ),
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kCream,
                height: 1.35,
              ),
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isLoading,
              minLines: 1,
              maxLines: 4,
              style: const TextStyle(color: kCream),
              cursorColor: kPurple,
              decoration: InputDecoration(
                filled: true,
                fillColor: kBackground,
                hintText: 'Ask CityFlow...',
                hintStyle: TextStyle(color: kCream.withValues(alpha: 0.56)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kCream.withValues(alpha: 0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPurple, width: 2),
                ),
              ),
              onSubmitted: (_) {
                if (!isLoading) onSend();
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: kPurple,
              foregroundColor: kCream,
            ),
            onPressed: isLoading ? null : onSend,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
