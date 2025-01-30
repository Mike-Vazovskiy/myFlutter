// lib/screens/chat_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../repositories/chat_repository.dart';
import '../services/ai_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  const ChatDetailScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _chatRepository = ChatRepository();
  final _aiService = AIService();
  final _controller = TextEditingController();

  Chat? _chat;

  @override
  void initState() {
    super.initState();
    _chat = _chatRepository.getChatById(widget.chatId);
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _chat == null) return;

    // Создаём сообщение от пользователя
    final userMessage = Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _chat = _chat?.copyWith(
        messages: [..._chat!.messages, userMessage],
      );
    });
    _controller.clear();

    // Сохраняем
    await _chatRepository.updateChat(_chat!);

    // Запрашиваем ответ от AI (заглушка)
    final aiMessage = await _aiService.getAIResponse(text);

    // Добавляем ответ
    setState(() {
      _chat = _chat?.copyWith(
        messages: [..._chat!.messages, aiMessage],
      );
    });

    await _chatRepository.updateChat(_chat!);
  }

  @override
  Widget build(BuildContext context) {
    if (_chat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Чат не найден')),
        body: const Center(child: Text('Ошибка: Чат не найден')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_chat!.title),
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: _chat!.messages.length,
              itemBuilder: (context, index) {
                final message = _chat!.messages[index];
                final isUser = message.isUser;

                // Цвет и оформление бабла
                final bubbleColor = isUser
                    ? const Color(0xFF2196f3) // бирюзовый для пользователя
                    : const Color(0xFF444654); // серовато-тёмный для ИИ

                // Иконка слева/справа
                final avatar = isUser
                    ? const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.android, color: Colors.white),
                      );

                // Выравнивание
                final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        avatar,
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        // Flexible, чтобы текст переносился и не "вываливался"
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(isUser ? 12 : 0),
                              bottomRight: Radius.circular(isUser ? 0 : 12),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style: const TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 8),
                        avatar,
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Поле ввода сообщения
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      hintStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white38),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196f3),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
