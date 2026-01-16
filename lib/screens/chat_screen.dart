import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoic_app/providers/theme_provider.dart';
import 'package:stoic_app/theme/app_text_styles.dart';
import 'package:stoic_app/theme/app_colors.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late Map<String, String> _responses;
  bool _responsesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  Future<void> _loadResponses() async {
    final String data = await rootBundle.loadString(
      'assets/data/chat_responses.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(data);
    _responses = jsonMap.map((k, v) => MapEntry(k, v.toString()));
    setState(() {
      _responsesLoaded = true;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (!_responsesLoaded || _messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();

    setState(() {
      _messages.add(
        ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _messageController.clear();

    // Simula delay de respuesta
    Future.delayed(const Duration(milliseconds: 800), () {
      String response = _getResponse(userMessage);

      setState(() {
        _messages.add(
          ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
        );
        _isLoading = false;
      });
    });
  }

  String _getResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    for (var key in _responses.keys) {
      if (lowerMessage.contains(key)) {
        return _responses[key]!;
      }
    }
    // Respuesta por defecto
    return '🤔 Interesante pregunta. Puedo ayudarte mejor si preguntas sobre:\n• Conceptos estoicos\n• Filósofos antiguos\n• Práctica diaria\n\nEscribe "ayuda" para ver más temas.';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_responsesLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF232323)
          : const Color(0xFFF7F6F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF232323) : const Color(0xFFF7F6F3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Mentor avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/base_rose.png'),
              ),
              const SizedBox(width: 12),
              // Mentor info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mentor Estoico',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark ? Colors.white : const Color(0xFF232323),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Siempre activo',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF6B6B6B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                icon: Icon(
                  themeProvider.themeModeIcon,
                  color: isDark ? Colors.white : const Color(0xFF232323),
                  size: 22,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: isDark ? Colors.white54 : const Color(0xFF232323),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 64,
                          color: context.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bienvenido al Chat Estoico',
                          style: AppTextStyles.h3.copyWith(
                            color: context.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Haz una pregunta para comenzar',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 20,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      return _ChatBubble(
                        message: message,
                        isUser: message.isUser,
                        isDark: isDark,
                      );
                    },
                  ),
          ),
          // Typing indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8, top: 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isDark
                        ? const Color(0xFF232323)
                        : const Color(0xFFF7F6F3),
                    backgroundImage: AssetImage(
                      'assets/images/mentor_avatar.png',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF353535)
                          : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDot(0),
                        const SizedBox(width: 4),
                        _buildDot(1),
                        const SizedBox(width: 4),
                        _buildDot(2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // Input area
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF353535) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Escribe tu reflexión... ',
                          hintStyle: AppTextStyles.bodySmall.copyWith(
                            color: context.textSecondary.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.textPrimary,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isLoading ? null : _sendMessage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFFFF6B35)
                            : const Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(0.3 + (_isLoading ? 0.5 : 0)),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;
  final bool isDark;

  const _ChatBubble({
    required this.message,
    required this.isUser,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final mentorBg = isDark ? const Color(0xFF353535) : const Color(0xFFF0F0F0);
    final userBg = isDark ? const Color(0xFFFF6B35) : const Color(0xFFFF6B35);
    final userText = Colors.white;
    final mentorText = isDark ? Colors.white : const Color(0xFF232323);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/mentor_avatar.png'),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isUser ? userBg : mentorBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isUser ? userText : mentorText,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: userBg,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
