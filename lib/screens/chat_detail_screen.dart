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

    // Создаём пользовательское сообщение
    final userMessage = Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Добавляем в локальный список сообщений
    setState(() {
      _chat = _chat?.copyWith(
        messages: [...?_chat?.messages, userMessage],
      );
    });
    _controller.clear();
    await _chatRepository.updateChat(_chat!);

    // Просим PyTorch-модель ответить
    final aiResponse = await AIService.getAIResponse(text);

    // Добавляем сообщение от AI
    final aiMessage = Message(
      text: aiResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _chat = _chat?.copyWith(
        messages: [...?_chat?.messages, aiMessage],
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

    // Далее стандартный UI, как было:
    return Scaffold(
      appBar: AppBar(title: Text(_chat!.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chat!.messages.length,
              itemBuilder: (context, index) {
                final message = _chat!.messages[index];
                final alignment =
                    message.isUser ? Alignment.centerRight : Alignment.centerLeft;
                final bgColor = message.isUser ? Colors.blue[100] : Colors.grey[300];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: const EdgeInsets.all(8),
                  alignment: alignment,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(message.text),
                );
              },
            ),
          ),
          // Поле ввода
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Введите сообщение...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
